#!/bin/sh

now=$(date +"%Y%m%d-%H%M%S")
filename="/tmp/screenshot-${now}.png"
import -screen $filename

echo "captured in $filename"


