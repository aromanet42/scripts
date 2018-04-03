#!/bin/sh

CURRENT_XRANDR=mono

while true
do

  connectedHDMI=`xrandr -q | grep " connected" | grep -E "(^DP.|HDMI.)" -o`

  if [ "$connectedHDMI" != "" ] && [ "$CURRENT_XRANDR" = "mono" ]
  then
    xrandr --output $connectedHDMI --auto
    xrandr --output $connectedHDMI --primary --left-of eDP1 --output eDP1 --auto
    CURRENT_XRANDR=dual
  fi

  if [ "$connectedHDMI" = "" ] && [ "$CURRENT_XRANDR" = "dual" ]
  then
    xrandr --output $connectedHDMI --off
    CURRENT_XRANDR=mono
  fi

  sleep 3s

done
