#!/bin/bash

if [ -e *.mkv ]; then
  file_type=".mkv"
else
  file_type=".mp4"
fi

mkdir ./temp
for file in *$file_type; do mv "$file" "in_$file"; done

# Function to fade in video
function fade_in() {
file_list1=(in_*)
  echo "Executing fade_in"
  for file in "${file_list1[@]}"; do
    ffmpeg -i "$file" -y -vf fade=in:0:30 -hide_banner -preset ultrafast "out_$file"
  done
mv in_* ./temp
}
export -f fade_in

# Function to fade out video
function fade_out() {
  file_list2=(out_*)
  echo "Executing fade_out"
  for file in "${file_list2[@]}"; do
    frame_count=$(ffmpeg -i $file -map 0:v:0 -c copy -f null -y /dev/null 2>&1 | grep -Eo 'frame= *[0-9]+ *' | grep -Eo '[0-9]+' | tail -1)
      frame_start=$((frame_count - 30))
      ffmpeg -i "$file" -y -vf fade=out:"$frame_start":30 -hide_banner -preset ultrafast "to_mux_$file"
  done
  mv out_* ./temp
}
export -f fade_out

bash -c "fade_in"
bash -c "fade_out"

ls --quoting-style=shell-always -1v *$file_type > tmp.txt
sed 's/^/file /' tmp.txt > list.txt && rm tmp.txt

ffmpeg -f concat -safe 0 -i list.txt -c:v copy -c:a aac -shortest -movflags +faststart muxed_fade$file_type

mv to_mux_* ./temp
rm list.txt
#rm -rf ./temp

exit 0
