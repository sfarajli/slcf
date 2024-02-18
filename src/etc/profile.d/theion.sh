export XDG_COLOR_DARK_GRAY="#282828" 
export XDG_COLOR_LESS_DARK_GRAY="#262626"
export XDG_COLOR_CREAM="#ebdbb2"
export XDG_COLOR_BROWN="#4E3524"
export XDG_COLOR_LIGHT_GRAY="#a89984"
export XDG_COLOR_ORANGE="#d79921"
export XDG_COLOR_RED="#cc241d"
export XDG_COLOR_MAGENTA="#b16286"
export XDG_COLOR_YELLOW_GREEN="#98971a"
export XDG_COLOR_LIGHT_GREEN="#689d6a"
export XDG_COLOR_CYAN="#458588"

# Theme
export XDG_COLOR_FOREGROUND=$XDG_COLOR_CREAM
export XDG_COLOR_BACKGROUND=$XDG_COLOR_DARK_GRAY

export XDG_COLOR_INACTIVE_FOREGROUND=$XDG_COLOR_LIGHT_GRAY
export XDG_COLOR_INACTIVE_BACKGROUND=$XDG_COLOR_LESS_DARK_GRAY

export XDG_COLOR_TRANSFORM=$XDG_COLOR_BROWN
export XDG_COLOR_INACTIVE_TRANSFORM=$XDG_COLOR_LESS_DARK_GRAY

export XDG_COLOR_WARINING=$XDG_COLOR_RED
export XDG_COLOR_NON_WARNING=$XDG_COLOR_CYAN
export XDG_COLOR_INTERACTIVE=$XDG_COLOR_YELLOW_GREEN

#Directories
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export ZSHRC="$XDG_CONFIG_HOME/zsh/zshrc"


# Environment variables
[ -x "$(command -v nvim)" ] && export EDITOR="nvim"
[ -x "$(command -v alacritty)" ] && export  TERMINAL="alacritty"
[ -x "$(command -v qutebrowser)" ] && export  BROWSER="qutebrowser"

export MAKEFLAGS="-j8"		# Reduce compile times
export LFS=/mnt/lfs		# For building Linux From Scratch
export LS_COLORS="di=01;36"	# Change the color of ls output to green for directory
