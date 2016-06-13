#!/usr/bin/env ruby

require "net/http"
require "json"

url = ENV['JENKINS_ENDPOINT'] + "/view/TV/api/json"

uri = URI(url)
Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https', 
  :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

    request = Net::HTTP::Get.new uri.request_uri
    request.basic_auth ENV['JENKINS_USERNAME'], ENV['JENKINS_TOKEN']

    response = http.request request

    result = JSON.parse(response.body)


    jobs_to_ignore = ['23.install-snasphot-to-last']
    colors = result["jobs"].select { |it| !jobs_to_ignore.include?(it["name"])}.map{ |i| i["color"]}.uniq
 
    title = 'Dvlp'

    if !colors.select { |it| it.end_with?('_anime') }.empty?
      title += ' RUN'
    end

    fail_colors = ['red', 'red_anime', 'yellow', 'yellow_anime']
    failed_job = colors & fail_colors
    if ! failed_job.empty?
      puts "<fc=#FF0000>" + title + "</fc>"
    else 
      puts "<fc=#00FF00>" + title + "</fc>"
    end

end
