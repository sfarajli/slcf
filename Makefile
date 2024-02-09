DEST_HOME ?= $(HOME)
PREFIX ?= /usr/local

CONFIRM_DOTFILES ?= false
CONFIRM_SCRIPTS ?= false
CONFIRM_ARCH ?= false


all:

install: dotfiles-install scripts-install arch-install

dotfiles-install:
ifeq ($(CONFIRM_DOTFILES),true)
	mkdir -p $(HOME)/.config
	cp -rv src/dotfiles/* $(HOME)/.config
	cp -v src/dotfiles/mimeapps.list $(HOME)
	cp -v src/dotfiles/zshrc $(HOME)/.zshrc
endif

scripts-install:
ifeq ($(CONFIRM_SCRIPTS),true)
	cp -vr src/scripts/* $(PREFIX)/bin
endif

arch-install:
ifeq ($(CONFIRM_ARCH),true)
	cp -v src/distros/arch-linux/pacman.conf /etc
endif
