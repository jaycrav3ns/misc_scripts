#!/bin/bash

yad --title="MP3 Album Art" --window-icon="applications-multimedia" --borders="15" \
--form --separator=" " --item-separator=" " --text-align="center" --image-on-top --image="insert-image" --text="Choose: File or Folder\nImage: PNG or JPG" \
--field=File:LBL "" \
--field="":FL \
--field=Folder:LBL "" \
--field="":DIR "" \
--field=Artwork:LBL "" \
--field="":FL \
--field="Backup?":CHK \

> /tmp/entries

if [ $? -ne 0 ]; then
    exit 1
fi

file_input=$(cat /tmp/entries | awk '{print $1}')
img_input=$(cat /tmp/entries | awk '{print $2}')
backup=$(cat /tmp/entries | awk '{print $3}')

if [[ $backup == TRUE ]]; then
    if [[ -d "$file_input" ]]; then
        cd "$file_input"
        mp3_files=$(find . -name "*.mp3")
        if [[ -n "$mp3_files" ]]; then
            tar cf "backup.tar" $mp3_files
        fi
    else
        cp "$file_input" "$file_input.bak"
    fi
fi

if [[ -n "$file_input" ]]; then
    if [[ ! -d "$file_input" ]]; then
        ffmpeg -i "$file_input" -i "$img_input" -map_metadata 0 -map 0 -map 1 -codec copy "out-${file_input##*/}" && mv "out-${file_input##*/}" "$file_input"
    else
        for file in "$file_input"/*.mp3; do
            ffmpeg -i "$file" -i "$img_input" -map_metadata 0 -map 0 -map 1 -codec copy "out-${file##*/}" && mv "out-${file##*/}" "$file"
        done
    fi
fi

rm /tmp/entries

exit 0
