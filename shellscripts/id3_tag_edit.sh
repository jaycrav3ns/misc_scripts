#!/bin/bash

f=$(yad --window-icon="document-open" --center --title "Select MP3 File" --file)

function fthelp () {
yad --window-icon="gtk-help" --title="Help?" --borders=10 --center --skip-taskbar --image-on-top --image="gtk-help" --text-align=center --text="None so far..." --button=gtk-close:0
}
export -f fthelp

# SCAN FOR EXISTING TAGS
scan_art=$(ffprobe -loglevel error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$f")
scan_alb=$(ffprobe -loglevel error -show_entries format_tags=album -of default=noprint_wrappers=1:nokey=1 "$f")
scan_tit=$(ffprobe -loglevel error -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "$f")
scan_tnum=$(ffprobe -loglevel error -show_entries format_tags=track -of default=noprint_wrappers=1:nokey=1 "$f")
scan_year=$(ffprobe -loglevel error -show_entries format_tags=year -of default=noprint_wrappers=1:nokey=1 "$f")
scan_gen=$(ffprobe -loglevel error -show_entries format_tags=genre -of default=noprint_wrappers=1:nokey=1 "$f")
scan_lyr=$(ffprobe -loglevel error -show_entries format_tags=lyrics -of default=noprint_wrappers=1:nokey=1 "$f")

# MAIN DIALOG
MD=$(yad --window-icon="multimedia-player" --center --geometry="285x435" --borders="10" --justify="center" --title="ID3 Edit" --buttons-layout="center" --text-align="center" --always-print-result --form \
--field="Artist:" "$scan_art" \
--field="Title:" "$scan_tit" \
--field="Album:" "$scan_alb" \
--field="Track:" "$scan_tnum" \
--field="Year:" "$scan_year" \
--field="Genre:" "$scan_gen" \
--field="Lyrics:":TXT "$scan_lyr" \
--field="Create Backup?":CHK "FALSE" > /tmp/entries \
--button=gtk-help:"bash -c fthelp" \
--button=gtk-apply:0 \
--button=gtk-quit:exit 1)

fld1=$(cut -d'|' -f1 < /tmp/entries)
fld2=$(cut -d'|' -f2 < /tmp/entries)
fld3=$(cut -d'|' -f3 < /tmp/entries)
fld4=$(cut -d'|' -f4 < /tmp/entries)
fld5=$(cut -d'|' -f5 < /tmp/entries)
fld6=$(cut -d'|' -f6 < /tmp/entries)
fld7=$(cut -d'|' -f7 < /tmp/entries)
fld8=$(cut -d'|' -f8 < /tmp/entries)

if [[ $fld8 == TRUE ]]
then cp "$f" "$f".bak
fi

if [[ $MD != 0 ]]
then rm /tmp/entries; exit 1
fi

ffmpeg -y -i "$f" -metadata artist="$fld1" -metadata title="$fld2" -metadata album="$fld3" -metadata track="$fld4" -metadata year="$fld5" -metadata genre="$fld6" -metadata lyrics="$fld7" -codec copy "$f".tmp.mp3 && echo $? && mv -f "$f".tmp.mp3 "$f"

yad --window-icon="gtk-yes" --title="Complete" --borders=10 --center --skip-taskbar --image-on-top --image="gtk-yes" --text-align=center --text="Complete!" --button=gtk-close:0

rm /tmp/entries
exit 0
