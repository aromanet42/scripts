#!/bin/sh

# diff is called by git with 7 parameters:
#  path old-file old-hex old-mode new-file new-hex new-mode
diffmerge $2 $5 --title1="Old" --title2="New $1"
#"$2" "$5" | cat

