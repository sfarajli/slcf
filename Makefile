.POSIX:

DWM = dwm-farajli-6.5
ST = st-farajli-0.9.2
DMENU = dmenu-farajli-5.3
SLSTATUS = slstatus-farajli-1.0
	
CONFDIR = $(HOME)/.config
MUSICDIR = $(HOME)/music
PROJDIR = $(HOME)/proj
BOOKDIR = $(HOME)/tproj
TESTPROJDIR = $(HOME)/tproj
BINDIR = $(HOME)/.local/bin

BASHRC = $(HOME)/.bashrc
ZSHRC = $(HOME)/.zshrc
ZPROFILE = $(HOME)/.zprofile
BASHPROFILE = $(HOME)/.bash_profile
GITCONFIG = $(HOME)/.gitconfig

COPY = cp -r
LINK = ln -sf

all: config scripts directory check

full: config scripts git directory desktop

desktop: $(DWM) $(ST) $(DMENU) $(SLSTATUS)

config:
	mkdir -p $(CONFDIR)/sites
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
	$(COPY) config/nvim			$(CONFDIR)
	$(COPY) config/x11 			$(CONFDIR)
	$(COPY) config/zathura 			$(CONFDIR)
	$(COPY) config/mimeapps.list 		$(CONFDIR)
	$(COPY) config/sites/bookmarks.txt 	$(CONFDIR)/sites
	$(LINK) $(CONFDIR)/shell/profile	$(BASHPROFILE)
	$(LINK) $(CONFDIR)/shell/profile	$(ZPROFILE)

git:
	$(COPY) config/git/gitconfig 		$(GITCONFIG)

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

$(DWM).tar.gz $(ST).tar.gz $(DMENU).tar.gz $(SLSTATUS).tar.gz: clean
	curl -LO https://farajli.net/archive/$@

$(DWM): $(DWM).tar.gz
$(ST): $(ST).tar.gz
$(DMENU): $(DMENU).tar.gz
$(SLSTATUS): $(SLSTATUS).tar.gz

$(DWM) $(ST) $(DMENU) $(SLSTATUS): 
	tar -xf $<
	cd $@; PREFIX=~/.local make install

check: 
	@-./dep.sh

dist: clean
	mkdir -p slcf/
	cp -R config distros scripts dep.sh Makefile README slcf/
	tar -czf slcf.tar.gz slcf/
	rm -rf slcf/

clean:
	rm -rf slcf/ slcf.tar.gz \
		$(DWM) $(DWM).tar.gz \
		$(ST) $(ST).tar.gz \
		$(DMENU) $(DMENU).tar.gz \
		$(SLSTATUS) $(SLSTATUS).tar.gz 

.PHONY: all config desktop scripts server arch-linux directory full check
