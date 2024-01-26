#!/bin/bash

## Optional date-stamp or hash-style
unique_id=$(tr -dc 'a-zA-Z0-9_-' < /dev/urandom | fold -w 6 | head -n 1)
#unique_id=$(date +"%Y_%m_%d-%H_%M_%S")

temp_file="$HOME/screencap_[$unique_id].png"

ffmpeg -an -f x11grab -s 1366x768 -i :0.0 -crf 0 -vframes 1 -y $HOME/$temp_file &>/dev/null
echo -e "\nScreenshot:\n"$temp_file"\n"

exit 0
