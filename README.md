# slcf - Suleyman's linux configuration files
My linux xorg configuration.

slcf only installs configuration to the home directory of the user running the Makefile 
and doesn't affect other users or make system-wide changes but it does overwrites the current configuration,
so, it's recommended to create a new user and run make as that user.
If you like the setup then you can install it for your main user.

# Instlallation 
1. Make sure to use Zsh or Bash as your interactive shell, have an internet connection, and install at least the build-time dependencies.

2. Create a new user (set shell either to Zsh or Bash):
```
useradd -m -s /bin/zsh <user> 
```

3. run 
``` bash
make
```
4. Log out, log back in, and run `startx` on the TTY.

# Dependencies 
## Build time dependencies
- curl
- fontconfig (fc-cache command)
- gcc 
- ld
- make
- ncurses (tic command)
- pkg-config
- tar

## Build time libraries
- libx11
- libxft
- libxinerama

## Program dependencies (optional but recommended)
- Xorg                               
- dunst                              
- fzf                                
- git                                
- lf >= r31                                 
- mpv                                
- libnotify (notify-send command)
- nsxiv or sxiv                         
- nvim >= 0.10.3 or vim                           
- picom                              
- qutebrowser
- scrot                              
- setxkbmap                          
- xorg-xinit
- xclip                              
- zathura                            
- zsh or bash

## Script dependencies (optional but recommended)
- brightnessctl                 
- pulseaudio                    
- xgamma                        
- xinput                        
- xset                          
- xwallpaper

# Notes
- Refer to [my dwm build man page](https://git.farajli.net/dwm.git/tree/dwm.1) for keybinds.

# Troubleshooting
- brightnessctl can require privileged user to function, to solve it refer to [brightnessctl page](https://github.com/Hummer12007/brightnessctl#Permissions).
- pulseaudio sometimes doesn't start automatically to start it manually run `pulseaudio --start`.
