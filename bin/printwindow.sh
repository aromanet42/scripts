#!/bin/sh

mkdir -p /tmp/screenshots

now=$(date +"%Y%m%d-%H%M%S")
filename="/tmp/screenshots/screenshot-${now}.png"
scrot $filename
kolourpaint $filename


notify-send "capture saved in $filename"

