#!/bin/bash

# Screenshot from terminal with timestamp & output to chosen directory.
# I have this: alias sshot='bash -c /script/path/sshot.sh' in .bash_aliases 

tnd=$(date +"(%m-%d-%y)-(%H.%M.%S)")
FL=~/Public/"scrot-"$tnd".png"

scrot -c -d 2 -q 100 $FL && echo "Saved."

exit 0
