#!/bin/bash

about_dialog() {
    yad --window-icon="help-faq" --title="About" --on-top --borders=10 --center --skip-taskbar --image="preferences-system-windows" --buttons-layout="center" --text-align=center --text="Always On Top!\n\nChange selected window's 'state' from\n'Below' to 'Above' &amp; Vice-versa.\n" --button=Close!application-exit!:0
}
export -f about_dialog

set_keybinding() {
	if [ ! -f ~/.ontop_tray_xkbrc ]; then
		current_binding='[none]'
	else
		current_binding=$(sed '2q;d' ~/.ontop_tray_xkbrc)
	fi

	remove_button='rm ~/.ontop_tray_xkbrc; echo "\"bash -c 'toggle_gnome'\"" > ~/.ontop_tray_xkbrc && xdotool windowkill window="cat /tmp/xwin_id_xkb" && bash -c set_keybinding'
	show_current=$(echo "$current_binding")

    yad --window-icon="input-keyboard" --borders="15" --on-top --skip-taskbar --title="Key Binding" \
        --text-align="center" --buttons-layout="center" --text="Current Binding\n$show_current\n" \
        --separator=" " --item-separator=" " --print-xid="/tmp/xwin_id_xkb" --form  \
        --field="Hold 1:":CB "Ctrl Alt Shift" \
        --field="Hold 2:":CB "Shift Ctrl Alt" \
        --field="Action:":entry "T" \
        --field=Remove-Binding:BTN "bash -c '$remove_button'" \
        --button=Confirm:0 \
        --button=Cancel:1 > /tmp/entries

    if [ $? -ne 0 ]; then
        exit 1
    fi

    entries=$(cut -d'|' -f1 < /tmp/entries)

    f1=$(echo "$entries" | awk '{print $1}')
    f2=$(echo "$entries" | awk '{print $2}')
    f3=$(echo "$entries" | awk '{print $3}')

    key_combo=$(echo "$f1+$f2+$f3" | tr ' ' '+')

    if [ ! -f ~/.ontop_tray_xkbrc ]; then
        echo "\"bash -c 'toggle_gnome'\"" > ~/.ontop_tray_xkbrc
    fi

    echo "$key_combo" > ~/.ontop_tray_xkbrc

    # Restart xbindkeys
    killall xbindkeys
    xbindkeys --file ~/.ontop_tray_xkbrc
}
export -f set_keybinding

tmp_error() {
	yad --skip-taskbar --on-top --window-icon="gtk-error" --title="Write Error" --image="gtk-error" \
		--button="Quit":1 \
		--text="Unable to write to /tmp\nCheck permissions for $USER."
	exit 1
}
export -f tmp_error

error_control() {
# Workaround:	Clicking OSK's enter-key will cause crosshair failure.
#						 	wmctrl, xdotool & xprop—all fail with 'onboard' OSK.
    yad --skip-taskbar --on-top --window-icon="dialog-question" --title="Retry?" --image="dialog-question" \
        --button="Try Again":0 \
        --button="Quit":1 \
        --text="Failed to focus on the window.\nDo you want to retry?" \

    response=$?

    if [ $response -eq 0 ]; then
				select_window
    else
        exit 1
    fi
}
export -f error_control

select_window() {
		xdotool selectwindow > /tmp/xwin_id

		if [ $? -ne 0 ]; then
			error_control
		fi

		if [ ! -f /tmp/xwin_id ]; then
    	tmp_error
		fi

		wmctrl -i -r "$(sed '1q;d' /tmp/xwin_id)" -b add,above
}
export -f select_window

select_new() {
		wmctrl -i -r $(sed '1q;d' /tmp/xwin_id) -b remove,above
    rm /tmp/xwin_id
		select_window
}
export -f select_new

toggle_gnome() {
    toggle_xwin_id=$(</tmp/xwin_id)
    xprop -id "$toggle_xwin_id" > /tmp/xwin_state
    check_state=$(cat /tmp/xwin_state | grep -q "_NET_WM_STATE(ATOM) = _NET_WM_STATE_ABOVE")
    
    if [ $? -eq 0 ]; then
        wmctrl -i -r "$toggle_xwin_id" -b remove,above
    else
        wmctrl -i -r "$toggle_xwin_id" -b add,above
    fi
}
export -f toggle_gnome

select_window

# Tray Icon & Menu
yad --notification --skip-taskbar --image="go-top" \
    --command="bash -c 'about_dialog'" \
    --menu=" Toggle !bash -c 'toggle_gnome' \
    | Select !bash -c 'echo "1" >> /tmp/xwin_id; select_new' \
    | Keybind !bash -c 'set_keybinding' \
    | Exit !bash -c 'wmctrl -i -r $(sed '1q;d' /tmp/xwin_id) -b remove,above && killall yad'" \
--text="Always On Top!"

exit 0
