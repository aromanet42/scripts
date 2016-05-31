#!/bin/sh

vol=`amixer sget Master | awk -F '[][]' '/dB/ { print $2 }'`

muted=`amixer sget Master | awk -F '[][]' '/dB/ { print $6 }'`

if [ "$muted" = "on" ]; then
  color="#00FF00"
  echo "♪ $vol"
else
  echo "<fc=#FF0000>♪ off</fc>"
fi

