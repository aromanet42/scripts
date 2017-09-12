#!/bin/sh

# creating pipe if does not exist yet
mkfifo /tmp/notif 2> /dev/null

echo "Will print whole window in 3 seconds..." > /tmp/notif
sleep 1
echo "Will print whole window in 2 seconds..." > /tmp/notif
sleep 1
echo "Will print whole window in 1 second..." > /tmp/notif
sleep 1

mkdir -p /tmp/screenshots

now=$(date +"%Y%m%d-%H%M%S")
filename="/tmp/screenshots/screenshot-${now}.png"
scrot $filename

echo "<action=kolourpaint $filename>capture saved in $filename</action>" > /tmp/notif
sleep 8
echo " " > /tmp/notif

