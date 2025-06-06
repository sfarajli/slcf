#!/bin/sh

# Format for entries `program,alternative_program:output_message`
# `alternative_program` and `message` are optional
check() {
    fail=0
    [ "${1}" = "-l" ] && { ISLIB=1; shift;} || ISLIB=0
    for entry in "${@}"; do
        missing=0
        program_part=${entry%%:*}
        program=${program_part%%,*}
        alt_program=${program_part#*,}
        msg=${entry#*:}

        [ "${msg}" = "${entry}" ] && msg="${program} is missing"

        if [ "${ISLIB}" -eq 1 ]; then
            pkg-config --exists "${program}" || missing=1
        elif ! command -v "${program}" > /dev/null 2>&1 &&
                ! command -v "${alt_program}" > /dev/null 2>&1; then
        missing=1
        fi

        [ "${missing}" -eq 1 ] && { echo "$msg" >&2; fail=1; }
    done
    return "${fail}"
}

retval=0

# Programs
check \
    Xorg                           \
    dunst                          \
    fzf                            \
    git                            \
    lf                             \
    mpv                            \
    picom                          \
    qutebrowser                    \
    scrot                          \
    startx:"xorg-xinit is missing" \
    sxiv,nsxiv                     \
    vim,nvim                       \
    zathura                        \
    zsh,bash || retval=1

# Script dependencies
check \
    brightnessctl                 \
    pactl:"pulseaudio is missing" \
    xgamma                        \
    xinput                        \
    xset                          \
    xwallpaper || retval=1

# Build dependencies
check \
    cc:"c compiler is missing"  \
    curl                        \
    ld:"linker is missing"      \
    make                        \
    tar || retval=1

# Libraries
if check pkg-config; then
    check -l \
        x11:"libX11 is missing"  \
        xft:"libXft is missing " \
        xinerama:"libXinerama is missing" || retval=1
else
    echo "Warning: Skipping library check since 'pkg-config' is missing" >&2
    retval=1
fi

exit "${retval}"
