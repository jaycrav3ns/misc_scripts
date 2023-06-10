#!/bin/bash

tdir="$HOME/Music/autotube"

read -p "Play song (i.e. ARTIST TITLE):" target

if [ ! -d "$tdir" ]
then
mkdir -p $tdir
fi

## Spinny, spin, spin!! ##
printf "		Processing... "
printf ""

(while :; do for c in / - \\ \|; do printf '%s\b' "$c"; sleep 1; done; done) &

yt-dlp -f 140 --extract-audio --audio-format mp3 --audio-quality 128k --quiet --no-warnings --add-metadata -o $tdir/"%(title)s.%(ext)s" -w --prefer-ffmpeg --postprocessor-args="-metadata purl="" -metadata comment="" -metadata description="" -metadata date=""" --exec "mpv --no-audio-display --aid=1" "ytsearch:$target"

printf "		Success!"; clear; sleep 1

## Command done, print newline & kill spinner job. ##
{ printf '\n'; kill $! && wait $!; } 2>/dev/null

exit 0
