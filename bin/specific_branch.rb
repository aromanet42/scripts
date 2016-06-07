#!/usr/bin/env ruby

require "net/http"
require "json"
require "date"

branch = ARGV[0]

url = ENV['JENKINS_ENDPOINT'] + "/view/" + branch + "/api/json"

uri = URI(url)
Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https',
  :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

    request = Net::HTTP::Get.new uri.request_uri
    request.basic_auth ENV['JENKINS_USERNAME'], ENV['JENKINS_TOKEN']

    response = http.request request

    result = JSON.parse(response.body)

    pipelines = result["pipelines"][0]["pipelines"]

    lesMiens = pipelines.select { |it| 
      descriptions = it["triggeredBy"].map{ |i| i["description"] }
      !descriptions.select { |i| i.include?('user Audrey Romanet') }.empty?
    }

    if lesMiens.empty?
      exit
    end

    monDernierMien = lesMiens[0]

    now = DateTime.now
    dateOfRun = DateTime.parse(monDernierMien["timestamp"])
    dateOfRun = dateOfRun.new_offset(now.offset) - now.offset
    interval = ((now.to_time - dateOfRun.to_time) / 3600).round

    #do not print if build runned to long ago
    if interval > 1
      exit
    end

    stages = monDernierMien["stages"].map{ |it| it["tasks"]}.flatten

    notCompleted = stages.select { |it| it["status"]["type"] != 'SUCCESS'}

    puts "Specific : "
    if notCompleted.size > 0
      status = stages.select { |it| it["status"]["type"] != 'IDLE' }
      .map { |it|
	type = it["status"]["type"]
	color = '00FF00'

	if type == 'UNSTABLE' || type == 'FAILED'
	  color = 'FF0000'
	elsif type == 'RUNNING' || type == 'QUEUED' 
	  color = 'FFA500'
	end

	name = it["name"]
	if name.length > 15
	  name = name[0, 6] + "..." + name[name.length - 5, name.length]
	end

	"<fc=#" + color + ">" + name + "</fc>"
      }

      puts status.join(' - ')

    else
      puts "<fc=#00FF00>ALL SUCCESS</fc>"
    end

    puts " -"
  end
