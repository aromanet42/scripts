#!/bin/sh

if type "gnome-screensaver" > /dev/null; then
  gnome-screensaver-command --lock
else
  if type "xscreensaver" > /dev/null; then
    xscreensaver-command -lock
  fi
fi

