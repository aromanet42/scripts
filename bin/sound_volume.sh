#!/bin/sh

vol=`amixer sget Master | awk -F '[][]' '/dB/ { print $2 }'`

muted=`amixer sget Master | awk -F '[][]' '/dB/ { print $6 }'`

if [ "$muted" = "on" ]; then
  color="#00FF00"
else
  color="#FF0000"
fi

echo "Vol:" $vol "(<fc="$color">"$muted"</fc>)"
