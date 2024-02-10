# Suleyman's Linux configuration files (SLCF)

## Installation 

This software doesn't have any configure script at the moment, 
instead you are supposed to use environment variables to configure 
the Makefile, such as:

```
export CONFIRM_DOTFILES=true  #enable installing the dotfiles

export CONFIRM_SCRIPTS=true   #enable installing scripts

export CONFIRM_ARCH=true      #enable installing arch specific (pacman.conf)

export DEST_HOME=/home/$USER         #give the user's home directory as the destination directory for installing the dotfiles (useful when running with sudo)

make install (or sudo make install if you want to install anything to the root directory)

```

Or if you don't know what you are doing you might just run the following command,
but be aware that this will overwrite you existing configuration files.

```
CONFIRM_SCRIPTS=true CONFIRM_DOTFILES=true DEST_HOME=/home/theion sudo make install
```

### WARNING
By default all environmental variables are false and if you want to install something at all you have to activate at least one environmental variable.


## Author 
Farajli Suleyman
