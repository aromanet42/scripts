#!/bin/sh

# creating pipe if does not exist yet
mkfifo /tmp/notif 2> /dev/null

echo "Select area to capture..." > /tmp/notif

sleep 0.2 # needed to avoid "couldn't grab keyboard:Resource temporarily unavailable" error

mkdir -p /tmp/screenshots

now=$(date +"%Y%m%d-%H%M%S")
filename="/tmp/screenshots/screenshot-${now}.png"
scrot -s $filename

echo "<action=kolourpaint $filename>capture saved in $filename</action>" > /tmp/notif
sleep 8
echo " " > /tmp/notif

