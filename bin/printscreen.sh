#!/bin/sh

sleep 0.2 # needed to avoid "couldn't grab keyboard:Resource temporarily unavailable" error

mkdir -p /tmp/screenshots

now=$(date +"%Y%m%d-%H%M%S")
filename="/tmp/screenshots/screenshot-${now}.png"
scrot -s $filename

notify-send "capture saved in $filename"

