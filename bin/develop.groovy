import groovy.json.JsonSlurper

def url = System.getenv()['JENKINS_ENDPOINT'] + "/view/TV/api/json"

def sout = new StringBuffer(), serr = new StringBuffer()
def process = "curl ${url}".execute()
process.consumeProcessOutput(sout, serr)
process.waitFor()

def json = sout.toString()

def slurper = new JsonSlurper()

def result = slurper.parseText(json)

def jobs_to_ignore = ['23.install-snasphot-to-last']
def colors = result.jobs.findAll {!jobs_to_ignore.contains(it.name)}*.color.unique()

def title = 'Dvlp'

if (colors.find { it.endsWith('_anime') } != null) {
  title += ' RUN'
}

def fail_colors = ['red', 'red_anime', 'yellow', 'yellow_anime']
if (colors.intersect(fail_colors)) {
  print "<fc=#FF0000>$title</fc>"
}
else {
  print "<fc=#00FF00>$title</fc>"
}

