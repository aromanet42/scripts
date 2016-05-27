#!/usr/bin/env ruby

require "net/http"
require "json"


uri = URI("https://api.jcdecaux.com/vls/v1/stations?contract=Paris&apiKey=852c74cea0b823b2ea06704e8f76cdde78cfdeaa")

Net::HTTP.start(uri.host, uri.port,
:use_ssl => uri.scheme == 'https', 
:verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

  request = Net::HTTP::Get.new uri.request_uri
  response = http.request request

  result = JSON.parse(response.body)


  station = result.select { |it| it["name"].include? "- LONGCHAMP" }[0]
  name = station["name"]
  name = name[name.index('-') + 2, name.size]

  puts name + ":" + station["available_bikes"].to_s

end
