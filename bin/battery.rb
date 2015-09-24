#!/usr/bin/env ruby
battery = ` upower -i $(upower -e | grep 'BAT') | grep -E "state|to\ full|percentage"`
split = battery.split(' ')
state = split[1]

if (state == "charging")
  percentage = split[8]
else
  percentage = split[3]
end

if (percentage.to_i < 30)
  puts "Battery: <fc=#FF0000>#{percentage}</fc>"
else
  puts "Battery: <fc=#00FF00>#{percentage}</fc>"
end
