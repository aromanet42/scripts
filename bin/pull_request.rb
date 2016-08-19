#!/usr/bin/env ruby

require "net/http"
require "json"
require "date"


url = ENV['REPO_ENDPOINT'] + "/issues?creator="+ ENV['REPO_USERNAME']

uri = URI(url)
Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https',
  :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

    request = Net::HTTP::Get.new uri.request_uri
    request.basic_auth ENV['REPO_USERNAME'], ENV['REPO_TOKEN']

    if File.exists?("/tmp/pr.tag")
      tagfile = File.open("/tmp/pr.tag", "rb")
      lastTag = tagfile.readline.strip
      lastResult = tagfile.readline.strip
      if !lastTag.to_s.empty?
	request['If-None-Match'] = lastTag
      end
    end

    response = http.request request

    if response.is_a?(Net::HTTPNotModified)
      puts lastResult
      exit
    end

    responseLastTag = response['ETag']
    tagfile = File.open("/tmp/pr.tag", "w")
    tagfile.puts responseLastTag
    tagfile.close

    list_of_pr = JSON.parse(response.body)

    if list_of_pr.empty?
      exit
    end

    #puts list_of_pr
   # if !list_of_pr["message"].nil?
   #   puts list_of_pr["message"]
   #   exit
   # end

    size = list_of_pr.size.to_i - 1

    to_print = ""

    (0..size).each { |i|

      monDernierMien = list_of_pr[i.to_i]
      pullRequestNumber = monDernierMien["number"]
      title=" PR "+pullRequestNumber.to_s

      uri = URI(monDernierMien["labels_url"].gsub(/\{.*\}/, ''))
      request = Net::HTTP::Get.new uri.request_uri
      request.basic_auth ENV['REPO_USERNAME'], ENV['REPO_TOKEN']
      response = http.request request
      result = JSON.parse(response.body)

      if ! result.empty?
	to_print += "<fc=##{result[0]["color"]}>#{title}</fc>"
      else

	uri = URI(monDernierMien["pull_request"]["url"])
	request = Net::HTTP::Get.new uri.request_uri
	request.basic_auth ENV['REPO_USERNAME'], ENV['REPO_TOKEN']
	response = http.request request
	result = JSON.parse(response.body)

	uri = URI(result["_links"]["statuses"]["href"])
	request = Net::HTTP::Get.new uri.request_uri
	request.basic_auth ENV['REPO_USERNAME'], ENV['REPO_TOKEN']
	response = http.request request
	result = JSON.parse(response.body)

	statuses = result.map { |it| it["state"] }.uniq

	if statuses.include?("failure")
	  to_print += "<fc=#FF0000>#{title}</fc>"
	elsif statuses.size == 1 && statuses[0] == "pending"
	  to_print += "<fc=#FFA500>#{title}</fc>"
	elsif statuses.include?("success")
	  to_print += "<fc=#00FF00>#{title}</fc>"
	end
      end
      to_print += " - "

    }


    puts to_print

    tagfile = File.open("/tmp/pr.tag", "a")
    tagfile.puts to_print
    tagfile.close

  end
