import groovy.json.JsonSlurper

def url = "https://audrey.romanet%40mirakl.com:9d7b11984ddd512eba1e18a9f568f1b1@jenkins.mirakl.net/view/09.DEVELOP%20PIPELINE/api/json"

def sout = new StringBuffer(), serr = new StringBuffer()
def process = "curl ${url}".execute()
process.consumeProcessOutput(sout, serr)
process.waitFor()

def json = sout.toString()

def slurper = new JsonSlurper()

def result = slurper.parseText(json)

def currentRun = result.pipelines[0].pipelines[0]

def statuses = currentRun.stages*.tasks*.status*.type.flatten().unique()


if (statuses.contains('IDLE') || statuses.contains('RUNNING')) {
  print "<fc=#FFA500>Dvlp</fc>"
}
else if (statuses.contains('UNSTABLE') || statuses.contains('FAILED')) {
  print "<fc=#FF0000>Dvlp</fc>"
}
else {
  print "<fc=#00FF00>Dvlp</fc>"
}

