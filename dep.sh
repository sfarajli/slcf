#!/bin/sh

check()
{
	for program in "${@}"; do
		if ! command -v "${program}" > /dev/null 2>&1; then
			echo "'${program}' is missing." >&2 
			retval=1;
		fi
	done;
}
check_double()
{
	if ! command -v "${1}" > /dev/null 2>&1 && ! command -v "${2}" > /dev/null 2>&1; then
			echo "'${1}' is missing." >&2 
	fi
}
check_with_msg()
{
	if ! command -v "${1}" > /dev/null 2>&1; then
			echo "${2}" >&2 
			retval=1;
	fi
}


retval=0

# Configurated programs
check \
	git     	\
	lf      	\
	mpv     	\
	picom   	\
	qutebrowser 	\
	zathura

check_double vim nvim # If at least one exists don't print error
check_double sxiv nsxiv
check_double zsh bash

# Programs required by the scripts 
check \
	dunst		\
	scrot		\
	brightnessctl

check_with_msg pactl "pulseaudio is missing."

# X11 dependencies
check \
	xinput      	\
	xset		\
	xgamma

check_with_msg startx "xorg-xinit is missing."

return "${retval}"
