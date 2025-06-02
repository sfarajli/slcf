#!/bin/sh

# Format for entries `program,alternative_program:output_message`
# `alternative_program` and `message` are optional
check() {
  for entry in "$@"; do
	program_part=${entry%%:*}
	program1=${program_part%%,*}
	alt_program=${program_part#*,}

	msg=${entry#*:} 
	[ "${msg}" = "${entry}" ] && msg="${program1} is missing"

	if ! command -v "${program1}" > /dev/null 2>&1 && ! command -v "${alt_program}" > /dev/null 2>&1; then
		echo "$msg" >&2 
	fi
  done
}

# Programs
check \
	git     			\
	lf      			\
	fzf      			\
	mpv     			\
	picom   			\
	qutebrowser 			\
	zathura				\
	vim,nvim			\
	sxiv,nsxiv			\
	zsh,bash			\
	dunst				\
	scrot				\
	startx:"xorg-xinit is missing"
# TODO: check for xorg-server

# Script dependencies
check \
	brightnessctl			\
	pactl:"pulseaudio is missing" 	\
	xinput				\
	xset				\
	xwallpaper			\
	xgamma

# Build dependencies
check \
	pkg-config			\
	curl				\
	tar				\
	make				\
	cc:"c compiler is missing" 	\
	ld:"linker is missing" 		

if ! command -v ld -L/usr/X11R6/lib -lX11 -lXinerama -lfontconfig -lXft > /dev/null 2>&1;then
	echo "Xorg library files missing" >&2
fi
