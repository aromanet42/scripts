#!/bin/sh

# 1. Check the existence of execFile file
# 2. If absent, OR if script launched with "repackage" arg, then recreates execFile
#     ./wrapper.sh repackage => to recreate execFile even if already exists
# 3. Run executable
#
execFile=$(ls ~/.config/my3status/target/my3status-java 2> /dev/null)
arg=$1


if [ -z "$execFile" ] || [ "repackage" = "$arg" ]; then
  cd /home/audrey.romanet/workspace/scripts/my3status-java
  mvn -Pnative clean native:compile -DskipTests  > /tmp/my3status-mvn.error
fi

/home/audrey.romanet/workspace/scripts/my3status-java/target/my3status-java 2> /tmp/my3status-java.error.log
