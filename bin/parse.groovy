import groovy.json.JsonSlurper

def url = "https://audrey.romanet%40mirakl.com:9d7b11984ddd512eba1e18a9f568f1b1@jenkins.mirakl.net/view/10.SPECIFIC%20BRANCH%20PIPELINE/api/json"

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
    return descriptions.contains('user Audrey Romanet')
}

def monDernierMien = lesMiens[0]

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
      } else if (type == 'RUNNING') {
	color = 'FFA500'
      }

    return "<fc=#$color>${it.name}</fc>"
  }

  print status.join(' - ')

}
else {
  print "<fc=#00FF00>ALL SUCCESS</fc>"
}
