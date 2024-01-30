#!/bin/bash

function help() {
  yad --window-icon="dialog-question" --title="Help" --borders=20 --center --close-on-unfocus --skip-taskbar --image-on-top --image="dialog-question" --text-align=center --no-buttons --text="1. Select directory to compress.\n2. Type your filename without extension.\n3. Select directory for output &amp; 'Save'"
}
export -f help

invalid_type() {
  yad --window-icon="dialog-warning" --title="Invalid Archive Type" --borders=20 --center --close-on-unfocus --skip-taskbar --image="dialog-warning" --text-align=center --timeout="10" --no-buttons --text="You must use 'tar', 'tar.bz2' or 'zip'"
}
export -f invalid_type

main=$(yad --title="Compress Folder" --window-icon="tap-create" --borders=10 --form \
--field="Source::MDIR" ~ \
--field="Name:" "" \
--field="Type::CBE" 'tar.bz2'\!'tar'\!'zip' \
--field="Save To::DIR" ~ \
--button=Help\!dialog-question:"bash -c help" \
--button=Cancel\!gtk-cancel:1 \
--button=Save\!gtk-apply:0 \
> /tmp/my_tar_yad)

exit_code=$?

if [[ $exit_code -ne 0 ]]; then
  exit 1
fi

field1=$(cut -d'|' -f1 < /tmp/my_tar_yad)
field2=$(cut -d'|' -f2 < /tmp/my_tar_yad)
field3=$(cut -d'|' -f3 < /tmp/my_tar_yad)
field4=$(cut -d'|' -f4 < /tmp/my_tar_yad)

source=$(echo "$field1" | sed 's/!/ /g')

case "$field3" in
	"tar.bz2")
	tar cf >(bzip2 -c > "$field4/$field2.$field3") -C "$source" .
	;;
	"tar")
	tar cf "$field4/$field2.$field3" -C "$source" .
	;;
	"tar.gz")
	tar -czvf "$field4/$field2.$field3" "$source"
	;;
	"zip")
	zip -r "$field4/$field2.$field3" "$source"
	;;
	*)
	bash -c "invalid_type"
	;;
esac

exit 0
