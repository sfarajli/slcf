.POSIX:

DWM = dwm-farajli-6.5
ST = st-farajli-0.9.2
DMENU = dmenu-farajli-5.3
SLSTATUS = slstatus-farajli-1.0
FONT1 = LiberationMono
FONT2 = JetBrainsMono

SOFTWARE = $(DWM) $(DMENU) $(SLSTATUS) $(ST)
FONTS = $(FONT1) $(FONT2)
ARCHIVE = $(SOFTWARE:=.tar.gz) $(FONTS:=.tar.gz)

CONFDIR = $(HOME)/.config
MUSICDIR = $(HOME)/music
PROJDIR = $(HOME)/proj
BOOKDIR = $(HOME)/tproj
TESTPROJDIR = $(HOME)/tproj
BINDIR = $(HOME)/.local/bin
FONTDIR = $(HOME)/.local/share/fonts/

BASHRC = $(HOME)/.bashrc
ZSHRC = $(HOME)/.zshrc
ZPROFILE = $(HOME)/.zprofile
BASHPROFILE = $(HOME)/.bash_profile
GITCONFIG = $(HOME)/.gitconfig

COPY = cp -r
LINK = ln -sf

all: config scripts directory

full: config scripts directory desktop

desktop: dmenu-install dwm-install slstatus-install st-install font1-install font2-install check

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
	sed '/# signingkey = <to be set manually>/d' config/git/gitconfig > $(GITCONFIG)
	@echo "#####################################################################"
	@echo "Warning: Git commit/tag signing is enabled but signingKey is not set." >&2
	@echo "#####################################################################"
	@echo "Configure it manually using:" >&2
	@echo "    gpg --list-secret-keys --keyid-format=long" >&2
	@echo "    git config --global user.signingkey <YOUR_KEY_ID>" >&2

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

sync: $(ARCHIVE)

$(ARCHIVE):
	curl -LO https://farajli.net/archive/$@

dmenu-install: $(DMENU).tar.gz
dwm-install: $(DWM).tar.gz
slstatus-install: $(SLSTATUS).tar.gz
st-install: $(ST).tar.gz
font1-install: $(FONT1).tar.gz
font2-install: $(FONT2).tar.gz

dmenu-install dwm-install slstatus-install st-install:
	tar xf $<
	PREFIX=~/.local make -C $$(basename $< .tar.gz) install

font1-install font2-install:
	tar xf $<
	$(COPY) $$(basename $< .tar.gz) $(FONTDIR)

check:
	@./dep.sh

fullcheck:
	@./dep.sh --optional

dist: clean
	mkdir -p slcf/
	cp -R config distros scripts dep.sh Makefile README slcf/
	tar -czf slcf.tar.gz slcf/
	rm -rf slcf/

clean:
	rm -rf slcf/ slcf.tar.gz $(ARCHIVE) $(SOFTWARE) $(FONTS)

.PHONY: all arch-linux check clean config desktop directory dist    \
	dmenu-install dwm-install font1-install font2-install fonts \
	full fullcheck git scripts server slstatus-install st-install sync
