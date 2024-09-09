#!/bin/sh

check()
{
	for program in "${@}"; do
		if ! command -v "${program}" > /dev/null 2>&1; then
			echo "'${program}' is missing." >&2 
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
	fi
}

# Configurated programs
check \
	git     	\
	lf      	\
	fzf      	\
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

check_with_msg pactl "'pulseaudio' is missing."

# X11 dependencies
check \
	xinput      	\
	xset		\
	xgamma

check_with_msg startx "'xorg-xinit' is missing."

# C X11 dependencies

check_with_msg cc "c compiler is missing"
check_with_msg ld "linker is missing"

if ! command -v ld -L/usr/X11R6/lib -lX11 -lXinerama -lfontconfig -lXft > /dev/null 2>&1;then
	echo "Xorg library files missing" 
fi
