#!/bin/bash

set_dir=$(yad --window-icon="folder" --title="Select Dir" --file --directory)

function renm() {
  for i in "${!files[@]}"; do
    mv "${files[$i]}" "${names[$i]}"
  done
}

export -f renm

readarray -t files < <(ls -1 "$set_dir")

yad --title="Image View & Rename Tool" --window-icon="insert-image" --geometry="500x300" --list --print-all --editable-cols="Rename" --separator="" --dclick-action="viewnior" --print-column=2 --hide-column=1 --grid-lines="both" --column="Filename" --column="Rename" "${files[@]}" "" > .tmp_file

readarray -t names < <(cat .tmp_file)

renm
exit 0

