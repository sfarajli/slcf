#!/bin/sh
. "lib_common.sh"

volume_handle() {
	case "${1}" in
	"up") pactl set-sink-volume @DEFAULT_SINK@ +"${2}"% ;;
	"down") pactl set-sink-volume @DEFAULT_SINK@ -"${2}"% ;;
	"set") pactl set-sink-volume @DEFAULT_SINK@ "${2}"% ;;
	"toggle") pactl set-sink-mute @DEFAULT_SINK@ toggle;;
	"get-current")
		pactl get-sink-volume @DEFAULT_SINK@ |
			sed -n 's/.* \([0-9][0-9]*%\).*/\1/p'
		;;
	"check_program")
		check_program "pactl" "pulseaudio must be installed" ;;

	esac
}

brightness_handle() {
	case "${1}" in
	"up") brightnessctl set +"${2}"% ;;
	"down") brightnessctl set "${2}"-% ;;
	"set") brightnessctl set "${2}"% ;;
	"get-current")
		printf '%s\n' \
			$(( ($(brightnessctl g) * 100)  / $(brightnessctl m) ))
		;;
	"check_program") check_program "brightnessctl"
	esac
}

screenshot_handle() {
	case "${1}" in
	"fullscreen") flags="-z" ;;
	"select") flags="-zs" ;;
	"focused-window") flags="-zu" ;;
	"check_program")
		check_program "scrot"
		return
	;;
	esac
	shift
	scrot "${flags}" "${1}"
}

wallpaper_handle() {
	case "${1}" in
	"clear") xwallpaper --clear ;;
	"set") xwallpaper --zoom "${2}" ;;
	"check_program") check_program "xwallpaper" ;;
	esac

}

screenlock_handle() {
	if [ "${#}" -eq 0 ]; then
		slock
	else
		slock -f "${1}"
	fi
}

input_device_handle() {
	case "$1" in
	"enable") xinput enable "${2}";;
	"disable") xinput disable "${2}";;
	"list") xinput list ;;
	"get-id")
		dev=$(xinput list --name-only | grep -i -m1 "${1}" ) || return 1
		printf "${dev#∼ }"
	;;
	"is_enabled")
    		xinput list-props "${2}" | grep -q "Device Enabled.*1$"
    		return $?
		;;
	"check_program") check_program "xclip" ;;
	esac
}

clipboard_handle() {
	case "${1}" in
	"text") xclip -selection clipboard ;;
	"file") xclip -selection clipboard -t "${2}" -i "${3}" ;;
	"get-clipboard") xclip -o -selection clipboard ;;
	esac
}

image_handle() {
	case "${1}" in
	"blur") mogrify -blur 0x8 "${2}" ;;
	"check_program")
		check_program "mogrify" "imagemagick must be installed"
	;;
	esac
}

file_handle() {
	file=$2
	case $1 in
	get-mime_type)
	m=$(file --mime-type -b "$file" 2>/dev/null) && { echo "$m"; return; }
	m=$(file -I "$file" 2>/dev/null) && { m=${m#*: }; m=${m%%;*}; echo "$m"; return; }
	m=$(file -i "$file" 2>/dev/null) && { m=${m#*: }; m=${m%%;*}; echo "$m"; return; }
	return 1
	;;
	esac
}

notify_handle() {
	case "${1}" in
	"reload") xsetroot -name "fsignal:1" ;;
	"send")
		echo "${2}" > /tmp/noti.fifo
		shift 2
		printf "%s\n" "$*" > /tmp/noti.txt
		xsetroot -name "fsignal:1"
	;;
	esac
}

compositor_handle() {
    case "${1}" in
        "start") pgrep -x picom >/dev/null || picom -b & ;;
        "stop") pgrep -x picom >/dev/null && pkill -x picom ;;
    esac
}

status_handle() {
	[ "${1}" = "reload" ] && slreload
}

menu_handle() {
	case "${1}" in
	"default") flags="" ;;
	"center") flags="-bw 1 -c -g 1 -l 25" ;;
	esac
	shift
	dmenu ${flags}
}
