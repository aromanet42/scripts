#!/usr/bin/env bash

# launching autorandr as 'aromanet' user
# because xrandr can not be runned as root (udev is launched as root)
su -c "DISPLAY=:0 autorandr -c" "aromanet"
