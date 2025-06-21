.POSIX:

DMENU       = dmenu-farajli-5.3
DWM         = dwm-farajli-6.5
FONT1       = LiberationMono
FONT2       = JetBrainsMono
SLSTATUS    = slstatus-farajli-1.0
ST          = st-farajli-0.9.2

FONTS       = $(FONT1) $(FONT2)
SOFTWARE    = $(DWM) $(DMENU) $(SLSTATUS) $(ST)
ARCHIVE     = $(SOFTWARE:=.tar.gz) $(FONTS:=.tar.gz)

BINDIR      = $(HOME)/.local/bin
BOOKDIR     = $(HOME)/tproj
CONFDIR     = $(HOME)/.config
FONTDIR     = $(HOME)/.local/share/fonts/
MUSICDIR    = $(HOME)/music
PROJDIR     = $(HOME)/proj
TESTPROJDIR = $(HOME)/tproj

BASHPROFILE = $(HOME)/.bash_profile
BASHRC      = $(HOME)/.bashrc
GITCONFIG   = $(HOME)/.gitconfig
ZCACHE      = $(HOME)/.cache/zsh/history
ZPROFILE    = $(HOME)/.zprofile
ZSHRC       = $(HOME)/.zshrc

COPY        = cp -r
LINK        = ln -sf

all: config directory scripts

full: config desktop directory scripts

desktop: dmenu-install dwm-install font1-install font2-install check slstatus-install st-install

config:
	mkdir -p                                $$(dirname $(ZCACHE))
	mkdir -p                                $(CONFDIR)/sites
	touch                                   $(ZCACHE)
	$(COPY) config/bash/bashrc              $(BASHRC)
	$(COPY) config/lf                       $(CONFDIR)
	$(COPY) config/mimeapps.list            $(CONFDIR)
	$(COPY) config/mpv                      $(CONFDIR)
	$(COPY) config/nsxiv                    $(CONFDIR)
	$(COPY) config/nvim                     $(CONFDIR)
	$(COPY) config/picom                    $(CONFDIR)
	$(COPY) config/qutebrowser              $(CONFDIR)
	$(COPY) config/shell                    $(CONFDIR)
	$(COPY) config/sites/bookmarks.txt      $(CONFDIR)/sites
	$(COPY) config/sxiv                     $(CONFDIR)
	$(COPY) config/vim                      $(CONFDIR)
	$(COPY) config/x11                      $(CONFDIR)
	$(COPY) config/zathura                  $(CONFDIR)
	$(COPY) config/zsh/zshrc                $(ZSHRC)
	$(LINK) $(CONFDIR)/shell/profile        $(BASHPROFILE)
	$(LINK) $(CONFDIR)/shell/profile        $(ZPROFILE)

git:
	sed '/# signingkey = <to be set manually>/d' config/git/gitconfig > $(GITCONFIG)
	@echo "#####################################################################"
	@echo "Warning: Git commit/tag signing is enabled but signingKey is not set." >&2
	@echo "#####################################################################"
	@echo "Configure it manually using:" >&2
	@echo "    gpg --list-secret-keys --keyid-format=long" >&2
	@echo "    git config --global user.signingkey <YOUR_KEY_ID>" >&2

scripts:
	mkdir -p          $(BINDIR)
	$(COPY) scripts/* $(BINDIR)

server:
	$(COPY) config/bash/bashrc $(BASHRC)
	$(COPY) config/lf          $(CONFDIR)
	$(COPY) config/shell       $(CONFDIR)
	$(COPY) config/vim         $(CONFDIR)
	$(COPY) config/zsh/zshrc   $(ZSHRC)
	$(COPY) scripts/noc

arch-linux:
	sudo $(COPY) distros/arch-linux/pacman.conf /etc

directory:
	mkdir -p \
		$(BINDIR)      \
		$(BOOKDIR)     \
		$(CONFDIR)     \
		$(MUSICDIR)    \
		$(PROJDIR)     \
		$(TESTPROJDIR)

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
	rm -rf slcf/ slcf.tar.gz $(ARCHIVE) $(FONTS) $(SOFTWARE)

.PHONY: all arch-linux check clean config desktop directory dist    \
	dmenu-install dwm-install font1-install font2-install fonts \
	full fullcheck git scripts server slstatus-install st-install sync
