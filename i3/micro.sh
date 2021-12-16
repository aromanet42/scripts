#!/usr/bin/env bash

# handle microphone ('Capture'), whatever its name

micAmixer=$(amixer | grep -B1 cvolume)
micName=$(expr "$micAmixer" : "Simple mixer control '\(.*\)'")

amixer set $micName toggle
