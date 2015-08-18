#!/bin/sh

export JAVA_HOME=/home/aromanet/dev/current_jdk
SCRIPT_NAME=$1
shift
echo `/home/aromanet/dev/groovy/bin/groovy /home/aromanet/workspace/scripts/bin/$SCRIPT_NAME.groovy $*`
