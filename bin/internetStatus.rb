#!/usr/bin/env ruby

require 'net/http'
require 'json'


@host = 'http://www.google.fr/'

url = URI(@host)

http = Net::HTTP.new(url.host, url.port)
http.read_timeout = 2
http.open_timeout = 2

begin
  resp = http.start() { |http|
    http.get(url.path)
  }

  puts ''
rescue Net::OpenTimeout
  puts '<fc=#FF0033> internet timeout </fc>'
end

