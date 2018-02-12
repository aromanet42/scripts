#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'date'
require 'yaml'
require 'openssl'

uri = URI("https://api.github.com/search/issues?q=involves:#{ENV['REPO_USERNAME']}+is:open+type:pr")


class GitRequests
  TAG_FILENAME = '/tmp/pr.tag'

  def initialize(http)
    @last_results = {}
    @next_results = {}
    @http = http
  end

  def fetch_response(uri, cache)
    request_uri = uri.request_uri
    request = Net::HTTP::Get.new request_uri
    request.basic_auth ENV['REPO_USERNAME'], ENV['REPO_TOKEN']

    last_etag = @last_results.fetch(request_uri, {})[:etag]
    if last_etag && cache
      request['If-None-Match'] = last_etag
    end


    response = @http.request request

    if response.is_a?(Net::HTTPNotModified)
      return @last_results[request_uri][:response]
    end


    etag = response['ETag']
    if etag
      @next_results[request_uri] = {:etag => etag}
    end

    result = JSON.parse(response.body)

    if block_given?
      result = yield(result)
    end

    if cache && !@next_results[request_uri].nil?
      @next_results[request_uri][:response] = result
    end

    result
  end

  def get_repo_name(pr)
    repo_url = pr['repository_url']
    repo_url[(repo_url.rindex('/')+1)..-1]
  end

  def get_statuses(pr)
    statuses_url = fetch_response URI(pr['pull_request']['url']), true do |json|
      if json['message']
	raise RuntimeError, json['message']
      end
      json['_links']['statuses']['href']
    end

    fetch_response URI(statuses_url.gsub('statuses', 'status')), true do |json|
      json['statuses']
    end
  end

  def load_last_results
    if File.exists?(TAG_FILENAME)
      results = YAML.load_file(TAG_FILENAME)
      if results
	@last_results = results
      end
    end

  end

  def print_new_results

    File.open(TAG_FILENAME, 'w') do |file|
      file.write @next_results.to_yaml
    end
  end

  def print_prs(uri)

    load_last_results

    list_of_pr = fetch_response uri, false do |json|
      json['items']
    end

    if list_of_pr.nil?
      return
    end

    all_output=list_of_pr.select {|pr|
      pr['user']['login'] == ENV['REPO_USERNAME'] || pr['assignees'].map{|a| a['login']}.include?(ENV['REPO_USERNAME'])
    }.map { |pr|
      pull_request_number = pr['number']
      repo_name = get_repo_name pr

      title=" <action=`google-chrome -newtab \"#{pr['html_url']}\"`>#{repo_name}\##{pull_request_number.to_s}</action>"
      output = "<fc=#b6b6b6>#{title}</fc>"

      begin
	statuses = get_statuses pr
      rescue RuntimeError
	statuses = []
      end

      unless statuses.empty?
        output += ': '
        output += statuses.map { |status|
	  status_name = status['context']
	  if status_name.downcase.end_with? '-pr'
	    status_name = 'pr'
	  elsif status_name.downcase.include? 'test'
	    status_name = 'qa'
	  else
	    status_name = nil
	  end

          if status['state'] == 'pending'
            "<fc=#FFA500>#{status_name || '?'}</fc> "
          elsif status['state'] == 'failure'
            "<fc=#FF0000>#{status_name || 'x'}</fc> "
          else
            "<fc=#00FF00>#{status_name || '✓'}</fc> "
          end
        }.sort.join('')
      end

      output
    }.join(' - ')

    # Writing result to file. If next API call is 'Not Modified' then we'll use this
    print_new_results

    all_output

  end

end

Net::HTTP.start(uri.host, uri.port,
                :use_ssl => uri.scheme == 'https',
                :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

  puts GitRequests.new(http).print_prs(uri)
end

