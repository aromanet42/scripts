import groovy.json.JsonSlurper
import groovy.time.TimeCategory

def url = args[0]

def sout = new StringBuffer(), serr = new StringBuffer()
def process = "curl ${url}".execute()
process.consumeProcessOutput(sout, serr)
process.waitFor()

def json = sout.toString()

def slurper = new JsonSlurper()

def result = slurper.parseText(json)

def pipelines = result.pipelines[0].pipelines


def lesMiens = pipelines.findAll {
    def descriptions = it.triggeredBy*.description
    return descriptions.find { it.contains('user Audrey Romanet') } != null
}

def monDernierMien = lesMiens[0]

def dateOfRun = Date.parse("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", monDernierMien.timestamp)
def interval = TimeCategory.minus(new Date(), dateOfRun)

boolean tooLong
// do not print if build runned to long ago
use(TimeCategory) {
  tooLong = interval > 1.hour
}
if (tooLong) {
  return ""
}

def stages = monDernierMien.stages*.tasks.flatten()

def notCompleted = stages.findAll {
   it.status.type != 'SUCCESS'
}

if(notCompleted.size() > 0) {
  def status = stages.findAll {
    it.status.type != 'IDLE'
  }.collect {
    def type = it.status.type
    def color = '00FF00'

    if (type == 'UNSTABLE' || type == 'FAILED') {
      color = 'FF0000'
    } else if (type == 'RUNNING' || type == 'QUEUED' ) {
      color = 'FFA500'
    }

    def name = it.name
    if (name.length() > 15) {
    	name = name.substring(0, 6) + "..." + name.substring(name.length() - 5)
    }

    return "<fc=#$color>${name}</fc>"
  }

  print status.join(' - ')

}
else {
  print "<fc=#00FF00>ALL SUCCESS</fc>"
}
