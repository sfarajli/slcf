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

all:

full: config scripts git desktop directory

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

desktop: dwm st dmenu

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

dwm: clean
	curl -LO https://farajli.net/software/dwm.tar.gz
	tar xf dwm.tar.gz
	cd dwm/; PREFIX="${HOME}"/.local make install

st: clean
	curl -LO https://farajli.net/software/st.tar.gz
	tar xf st.tar.gz
	cd st/; PREFIX="${HOME}"/.local make install

dmenu: clean
	curl -LO https://farajli.net/software/dmenu.tar.gz
	tar xf dmenu.tar.gz
	cd dmenu/; PREFIX="${HOME}"/.local make install

arch-linux:
	sudo $(COPY) distros/arch-linux/pacman.conf /etc

directory:
	mkdir -p 	$(CONFDIR) \
			$(MUSICDIR) \
			$(PROJDIR) \
			$(BOOKDIR) \
			$(TESTPROJDIR) \
			$(BINDIR)
clean:
	rm -rf dwm st dmenu dwm.tar.gz st.tar.gz dmenu.tar.gz

.PHONY: all config scripts server desktop arch-linux directory dwm st dmenu clean full
