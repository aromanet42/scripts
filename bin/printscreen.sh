#!/bin/sh

mkdir /tmp/screenshots

now=$(date +"%Y%m%d-%H%M%S")
filename="/tmp/screenshots/screenshot-${now}.png"
import -window root -pause 3 $filename 
kolourpaint $filename

echo "captured in $filename"

