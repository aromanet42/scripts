#!/usr/bin/env ruby

require 'nokogiri' #sudo gem install nokogiri
require 'open-uri'


@host = 'http://10.199.54.82/backoffice/login'
@project = 'BO TOP3'


begin
  page = Nokogiri::HTML(open(@host))

  version = page.css(".login-footer").text
  puts "<fc=#00FF33> #{@project} : #{version}</fc>"
rescue HTTPError
  puts "<fc=#FF0000> #{@project} deploying</fc>"
end


