#!/bin/sh

# Format for entries `program,alternative_program:output_message`
# `alternative_program` and `message` are optional
check() {
    retval=0
    [ "${1}" = "-l" ] && { ISLIB=1; shift;} || ISLIB=0
    for entry in "${@}"; do
        fail=0
        program_part=${entry%%:*}
        program=${program_part%%,*}
        alt_program=${program_part#*,}
        msg=${entry#*:}

        [ "${msg}" = "${entry}" ] && msg="${program} is missing"

        if [ "${ISLIB}" -eq 1 ]; then
            pkg-config --exists "${program}" || fail=1
        elif ! command -v "${program}" > /dev/null 2>&1 &&
                ! command -v "${alt_program}" > /dev/null 2>&1; then
        fail=1
        fi

        [ "${fail}" -eq 1 ] && { echo "$msg" >&2; retval=1; }
    done
    return "${retval}"
}

# Programs
check \
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
    zsh,bash                       \
# TODO: check for xorg-server

# Script dependencies
check \
    brightnessctl                 \
    pactl:"pulseaudio is missing" \
    xgamma                        \
    xinput                        \
    xset                          \
    xwallpaper

# Build dependencies
check \
    cc:"c compiler is missing"  \
    curl                        \
    ld:"linker is missing"      \
    make                        \
    tar

# Libraries
if check pkg-config; then
    check -l \
        x11      \
        xft      \
        xinerama
else
    echo "Warning: Skipping library check since 'pkg-config' is missing" >&2
fi
