#!/bin/sh

SCRIPT_NAME=$1
shift
echo `/usr/bin/ruby /home/aromanet/workspace/scripts/bin/$SCRIPT_NAME.rb $*`
