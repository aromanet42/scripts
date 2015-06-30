#!/bin/sh

now=$(date +"%Y%m%d-%H%M%S")
filename="/tmp/screenshot-${now}.png"
import -window root -pause 3 $filename 
gthumb $filename

echo "captured in $filename"

