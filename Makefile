.POSIX:

DMENU           = dmenu_farajli-5.3.0
DWM             = dwm_farajli-6.5.1
FONT1           = LiberationMono
FONT2           = JetBrainsMono
SLSTATUS        = slstatus_farajli-1.0.0
ST              = st_farajli-0.9.2.0

FONTS           = $(FONT1) $(FONT2)
SOFTWARE        = $(DWM) $(DMENU) $(SLSTATUS) $(ST)
ARCHIVE         = $(SOFTWARE:=.tar.gz) $(FONTS:=.tar.gz)

BINDIR          = $(HOME)/.local/bin
CONFDIR         = $(HOME)/.config
FONTDIR         = $(HOME)/.local/share/fonts/

BASHPROFILE     = $(HOME)/.bash_profile
BASHRC          = $(HOME)/.bashrc
GITCONFIG       = $(HOME)/.gitconfig
ZCACHE          = $(HOME)/.cache/zsh/history
ZPROFILE        = $(HOME)/.zprofile
ZSHRC           = $(HOME)/.zshrc

INSTALL_TARGETS = dmenu-install dwm-install font1-install font2-install slstatus-install st-install
DIRECTORIES     = $(BINDIR) $(CONFDIR) $(FONTDIR)

COPY            = cp -r
LINK            = ln -sf

all: config $(DIRECTORIES) scripts

full: all desktop

desktop: $(INSTALL_TARGETS)

$(BINDIR) $(CONFDIR) $(FONTDIR):
	mkdir -p $@

config: $(CONFDIR)
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
	$(COPY) config/wallpapers               $(CONFDIR)
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

scripts: $(BINDIR)
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

sync: $(ARCHIVE)

$(ARCHIVE):
	curl -LO https://farajli.net/archive/$@

dmenu-install:    $(DMENU).tar.gz    $(BINDIR)
dwm-install:      $(DWM).tar.gz      $(BINDIR)
slstatus-install: $(SLSTATUS).tar.gz $(BINDIR)
st-install:       $(ST).tar.gz       $(BINDIR)
font1-install:    $(FONT1).tar.gz    $(FONTDIR)
font2-install:    $(FONT2).tar.gz    $(FONTDIR)

dmenu-install dwm-install slstatus-install st-install:
	tar xf $<
	PREFIX=~/.local make -C $$(basename $< .tar.gz) install

font1-install font2-install:
	tar xf $<
	$(COPY) $$(basename $< .tar.gz) $(FONTDIR)
	fc-cache

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

.PHONY: all arch-linux check clean config desktop directory dist \
	fonts full fullcheck git scripts server sync \
	$(INSTALL_TARGETS)
