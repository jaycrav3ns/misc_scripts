#!/bin/bash

ico=$""

url=$(yad --geometry="300x100" --borders="16" --window-icon="applications-multimedia" --center --title="Plsgrab-YT2MP3" --image="$ico" --text-align="center" --text="URL Video/Playlist" --entry)

if [[ $? -ne 0 ]]; then exit 1
else

cd $HOME/Music; mkdir temp; cd temp

yt-dlp -x -f 140 --audio-format mp3 --audio-quality 128K --no-post-overwrites --part -o "%(playlist_index)02d - %(title)s.%(ext)s" --hls-use-mpegts --add-metadata --embed-thumbnail --prefer-ffmpeg --extractor-args="ffmpeg:-metadata Comment="";-metadata Description="";-metadata PublisherURL="$url"" $url

fi

getart=$(ffprobe -loglevel error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 ./01*mp3)
getalb=$(ffprobe -loglevel error -show_entries format_tags=album -of default=noprint_wrappers=1:nokey=1 ./01*mp3)

mkdir "$getart - $getalb"; cd "$getart - $getalb"; mv ../*mp3 ./
cd "$HOME"/Music; mv "$HOME"/Music/temp/"$getart - $getalb" "$HOME"/Music
rm -d "$HOME"/Music/temp

yad --window-icon="insert-link" --center --title="Done" --image="insert-link" --text-align="center" --text="Done." --timeout="5"

exit 0
