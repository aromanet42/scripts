#!/usr/bin/env ruby

require 'net/http'
require 'json'


@host = 'http://10.199.54.202/hudson/'

def get_or_error(page)
  url = URI(@host + page)

  http = Net::HTTP.new(url.host, url.port)
  http.read_timeout = 5
  http.open_timeout = 5
  resp = http.start() { |http|
    http.get(url.path)
  }

  if (resp.code.to_i >= 400)
    puts '<fc=#FF0033> unavailable </fc>'
    exit 
  end
  return JSON.parse(resp.body)
end


jobs = get_or_error("view/Sigmaplus/api/json?tree=jobs[name]")


remaining_times = []
building = false

jobs['jobs'].each do |job|

  json = get_or_error("job/#{job['name']}/lastBuild/api/json?tree=timestamp,estimatedDuration,building")

  current_building = json['building']
  building = current_building || building

  if (current_building)
    estimatedDuration = json['estimatedDuration']/1000
    timestamp = json['timestamp']/1000

    now = Time.now.to_i

    spent = now - timestamp
    remaining_times << estimatedDuration - spent
  end
end

if (building)
  max_remaining = remaining_times.max

  if max_remaining < 0
    result = "N/A"
  else
    seconds = max_remaining % 60
    minutes = (max_remaining / 60) % 60

    result = format("%02dmn%02ds", minutes, seconds) #=> "15mn5s"
  end

  puts "<fc=#FF0033> hudson build (#{result}) </fc>"
else
  puts '<fc=#00FF33> hudson waiting </fc>'
end
