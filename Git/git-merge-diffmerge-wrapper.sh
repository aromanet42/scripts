#!/bin/sh

# diff is called by git with 7 parameters:
#  path old-file old-hex old-mode new-file new-hex new-mode
diffmerge --merge --result="$4" "$1" "$2" "$3" --title3="Mine" --title2="Merged: $4" --title1="Theirs"
#"$1" "$2" "$3" --result="$4" --title1="Mine" --title2="Merging to: $4" --title3="Theirs"
