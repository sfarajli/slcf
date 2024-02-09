# Configuration files for gnu/linux systems

## installation 

This software doesn't have any configure script at the moment, 
instead you are supposed to use environment variables to configure 
the Makefile, such as:

```
export CONFIRM_DOTFILES=true  #enable installing the dotfiles

export CONFIRM_SCRIPTS=true   #enable installing scripts

export CONFIRM_ARCH=true      #enable installing arch specific (pacman.conf)

DEST_HOME=/home/$USER         #give the user's home directory as the destination directory for installing the dotfiles (useful when running with sudo)

```

Or you might just run all of them in one line, as:

```
export CONFIRM_DOTFILES=false export CONFIRM_SCRIPTS=true make install
```

### WARNING
By default all environmental variables are false and if you want to install something at all you have to activate at least one environmental variable.


## Author 
Farajli Suleyman
