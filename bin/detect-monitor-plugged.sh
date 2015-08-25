#!/bin/sh


xrandr --output HDMI1 --auto
xrandr --output HDMI1 --primary --left-of eDP1 --output eDP1 --auto
CURRENT_XRANDR=dual


while true
do

  deviceStatusFile=`ls /sys/class/drm/ | grep HDMI`

  deviceStatus=`cat /sys/class/drm/$deviceStatusFile/status`

  if [ "$deviceStatus" = "connected" ] && [ "$CURRENT_XRANDR" = "mono" ]
  then
    xrandr --output HDMI1 --auto
    xrandr --output HDMI1 --primary --left-of eDP1 --output eDP1 --auto
    CURRENT_XRANDR=dual
  fi

  if [ "$deviceStatus" != "connected" ] && [ "$CURRENT_XRANDR" = "dual" ]
  then
    xrandr --output HDMI1 --off
    CURRENT_XRANDR=mono
  fi

  sleep 3s

done
