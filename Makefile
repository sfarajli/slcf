.POSIX:

DESKTOP     := menu status term wm locker
STD_CONFIGS := git lf mpv nsxiv nvim picom qutebrowser sxiv vim x11 zathura
SHARE_DATA  := wallpapers sites

STAGEDIR    := image
CONFIG_DIR  := .config
DATADIR     := .local/share
BINDIR      := .local/bin

all: $(DESKTOP) scripts bash zsh mimeapps shell $(SHARE_DATA) $(STD_CONFIGS)

install: all
	cp -RpP $(STAGEDIR)/. ~/

scripts:
	mkdir -p $(STAGEDIR)/$(BINDIR)
	cp -R local/bin/. $(STAGEDIR)/$(BINDIR)/

bash:
	mkdir -p $(STAGEDIR)
	cp config/bash/bashrc $(STAGEDIR)/.bashrc

zsh:
	mkdir -p $(STAGEDIR)/.local/cache
	touch $(STAGEDIR)/.local/cache/history
	cp config/zsh/zshrc $(STAGEDIR)/.zshrc

shell:
	mkdir -p $(STAGEDIR)/$(CONFIG_DIR)
	cp -R config/shell $(STAGEDIR)/$(CONFIG_DIR)/
	ln -sf $(CONFIG_DIR)/shell/profile $(STAGEDIR)/.bash_profile
	ln -sf $(CONFIG_DIR)/shell/profile $(STAGEDIR)/.zprofile

mimeapps:
	mkdir -p $(STAGEDIR)/$(CONFIG_DIR)
	cp config/mimeapps.list $(STAGEDIR)/$(CONFIG_DIR)/

$(SHARE_DATA):
	mkdir -p $(STAGEDIR)/$(DATADIR)
	cp -R local/share/$@ $(STAGEDIR)/$(DATADIR)/

$(STD_CONFIGS):
	mkdir -p $(STAGEDIR)/$(CONFIG_DIR)
	cp -R config/$@ $(STAGEDIR)/$(CONFIG_DIR)/

$(DESKTOP):
	mkdir -p "$$(pwd)/$(STAGEDIR)/.local"
	PREFIX="$$(pwd)/$(STAGEDIR)/.local" $(MAKE) -C x11/$@ install

clean:
	@for dir in $(DESKTOP); do \
		$(MAKE) -C x11/$$dir clean; \
	done
	rm -rf $(STAGEDIR)

.PHONY: all install clean scripts bash zsh shell mimeapps $(SHARE_DATA) $(STD_CONFIGS) $(DESKTOP)
