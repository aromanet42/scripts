import groovy.json.JsonSlurper

def url = "https://api.jcdecaux.com/vls/v1/stations?contract=Paris&apiKey=852c74cea0b823b2ea06704e8f76cdde78cfdeaa"

def sout = new StringBuffer(), serr = new StringBuffer()
def process = "curl ${url}".execute()
process.consumeProcessOutput(sout, serr)
process.waitFor()

def json = sout.toString()
def slurper = new JsonSlurper()
def result = slurper.parseText(json)


def station = result.find { it.name.contains "- LONGCHAMP" }
def name = station.name
name = name.substring(name.indexOf('-') + 2)

print name + ":" + station.available_bikes
