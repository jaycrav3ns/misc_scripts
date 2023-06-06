#!/bin/bash

function help() {
  yad --window-icon="dialog-question" --title="Help" --borders=20 --center --close-on-unfocus --skip-taskbar --image-on-top --image="dialog-question" --text-align=center --no-buttons --text="1. Select directory to compress.\n2. Type your filename without extension.\n3. Select directory for output &amp; 'Save'"
}
export -f help

main=$(yad --title="Compress Folder" --window-icon="tap-create" --borders=10 --form \
--field="Source::MDIR" ~ \
--field="Name:" "" \
--field="Type::CBE" 'tar.bz2'\!'tar'\!'zip' \
--field="Save To::DIR" ~ \
--field="Safe Mode:CHK" \
--button=Help\!dialog-question:"bash -c help" \
--button=Cancel\!gtk-cancel:1 \
--button=Save\!gtk-apply:0)

exit_code=$?

if [[ $exit_code -ne 0 ]]; then
  exit 1
elif [[ $field5 == TRUE ]]; then
  new_src="$HOME/.tmp_tarbz2"
  mkdir -p "$new_src"
  cp -aR --parents "$field1" "$new_src"
else
  field1=$(echo "$main" | awk -F '|' '{print $1}')
  field2=$(echo "$main" | awk -F '|' '{print $2}')
  field3=$(echo "$main" | awk -F '|' '{print $3}')
  field4=$(echo "$main" | awk -F '|' '{print $4}')
  field5=$(echo "$main" | awk -F '|' '{print $5}')

  case "$field3" in
    "tar.bz2")
      tar cf >(bzip2 -c > "$field4/$field2.$field3") -C "$field1" .
      ;;
    "tar")
      tar cf "$field4/$field2.$field3" -C "$field1" .
      ;;
    "zip")
      zip -r "$field4/$field2.$field3" "$field1"
      ;;
    *)
      echo "Invalid type selected."
      exit 1
      ;;
  esac
fi

if [ ! -d $HOME/.tmp_tarbz2 ] ; then
exit 0
 else
rm -rf $HOME/.tmp_tarbz2
fi

exit 0
