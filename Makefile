# Directories
CONFDIR=$(HOME)/.config
MUSICDIR=$(HOME)/music
PROJDIR=$(HOME)/proj
BOOKDIR=$(HOME)/tproj
TESTPROJDIR=$(HOME)/tproj
BINDIR=$(HOME)/.local/bin

# Files
BASHRC=$(HOME)/.bashrc
ZSHRC=$(HOME)/.zshrc
ZPROFILE=$(HOME)/.zprofile
BASHPROFILE=$(HOME)/.bash_profile
GITCONFIG=$(HOME)/.gitconfig

COPY=cp -r
LINK=ln -sf

all: config scripts

config:
	mkdir -p $(CONFDIR)
	$(COPY) config/bash/bashrc		$(BASHRC)
	$(COPY) config/zsh/zshrc		$(ZSHRC)
	$(COPY) config/lf 			$(CONFDIR)
	$(COPY) config/mpv 			$(CONFDIR)
	$(COPY) config/sxiv 			$(CONFDIR)
	$(COPY) config/nsxiv 			$(CONFDIR)
	$(COPY) config/picom 			$(CONFDIR)
	$(COPY) config/qutebrowser 		$(CONFDIR)
	$(COPY) config/shell 			$(CONFDIR)
	$(COPY) config/vim			$(CONFDIR)
	$(COPY) config/x11 			$(CONFDIR)
	$(COPY) config/zathura 			$(CONFDIR)
	$(COPY) config/mimeapps.list 		$(CONFDIR)

	$(LINK) $(CONFDIR)/shell/profile	$(BASHPROFILE)
	$(LINK) $(CONFDIR)/shell/profile	$(ZPROFILE)

git:
	$(COPY) config/gitconfig 		$(GITCONFIG)


scripts:
	mkdir -p $(BINDIR)
	$(COPY) scripts/* 			$(BINDIR)

server:
	$(COPY) config/bash/bashrc 	$(BASHRC)
	$(COPY) config/zsh/zshrc 	$(ZSHRC)
	$(COPY) config/lf 		$(CONFDIR)
	$(COPY) config/shell		$(CONFDIR)
	$(COPY) config/vim		$(CONFDIR)

arch-linux:
	sudo $(COPY) distros/arch-linux/pacman.conf /etc

directory:
	mkdir -p 	$(CONFDIR) \
			$(MUSICDIR) \
			$(PROJDIR) \
			$(BOOKDIR) \
			$(TESTPROJDIR) \
			$(BINDIR)



.PHONY: all config scripts server arch-linux directory
