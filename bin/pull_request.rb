#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'date'
require 'yaml'

uri = URI("https://api.github.com/search/issues?q=author:#{ENV['REPO_USERNAME']}+is:open+type:pr")


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

    if cache
      @next_results[request_uri][:response] = result
    end

    result
  end

  def get_repo_name(pr)
    repo_url = pr['repository_url']
    repo_url[(repo_url.rindex('/')+1)..-1]
  end

  def get_labels(pr)
    uri = URI(pr['labels_url'].gsub(/\{.*\}/, ''))
    fetch_response uri, true do |json|
      json
    end
  end

  def get_statuses(pr)
    statuses_url = fetch_response URI(pr['pull_request']['url']), true do |json|
      json['_links']['statuses']['href']
    end

    fetch_response URI(statuses_url), true do |json|
      json.group_by{|it| it['context']}
          .collect {|k, v| v.first['state']}
    end
  end

  def load_last_results
    if File.exists?(TAG_FILENAME)
      @last_results = YAML.load_file(TAG_FILENAME)
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

    output=''

    list_of_pr.each { |pr|

      pull_request_number = pr['number']

      pr_labels = get_labels pr

      repo_name = get_repo_name pr

      title=" [#{repo_name}] PR #{pull_request_number.to_s}"

      if !pr_labels.empty?
        output += "<fc=##{pr_labels[0]['color']}>#{title}</fc>"
      else

        statuses = get_statuses pr

        if statuses.include?('pending')
          output += "<fc=#FFA500>#{title}</fc>"
        elsif statuses.include?('failure')
          output += "<fc=#FF0000>#{title}</fc>"
	else
          output += "<fc=#00FF00>#{title}</fc>"
        end
      end
      output += ' - '

    }

    # Writing result to file. If next API call is 'Not Modified' then we'll use this
    print_new_results

    output

  end

end

Net::HTTP.start(uri.host, uri.port,
                :use_ssl => uri.scheme == 'https',
                :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

  puts GitRequests.new(http).print_prs(uri)
end

