#!/usr/bin/env bash

# handle volume, whatever its name

volumeAmixer=$(amixer | grep -B1 pvolume -m1)
volumeName=$(expr "$volumeAmixer" : "Simple mixer control '\(.*\)'")

case "$1" in
  toggle)
    amixer set $volumeName toggle
    ;;
  up)
    amixer -q sset $volumeName 3%+
    ;;
  down)
    amixer -q sset $volumeName 3%-
    ;;
esac
