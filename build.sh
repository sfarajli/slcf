#!/bin/sh

set -e

BINDIR="${HOME}/.local/bin"
CONFDIR="${HOME}/.config"
DATADIR="${HOME}/.local/share"
FONTDIR="${HOME}/.local/share/fonts"
BASHRC="${HOME}/.bashrc"
BASHPROFILE="${HOME}/.bash_profile"
ZPROFILE="${HOME}/.zprofile"
ZSHRC="${HOME}/.zshrc"
ZCACHE="${HOME}/.cache/zsh/history"
GITCONFIG="${HOME}/.gitconfig"

dwm_version="dwm_farajli-6.5.2"
dmenu_version="dmenu_farajli-5.3.0"
slstatus_version="slstatus_farajli-1.0.1"
st_version="st_farajli-0.9.2.1"

MAKEDIR() { mkdir -pv "${1}"; }

COPY() {
	cp -r "${@}"

	printf 'copied'
	while [ "$#" -gt 1 ]; do
	    printf ' %s' "$1"
	    shift
	done
	printf ' -> %s\n' "$1"
}

LINK() {
	ln -sf "${1}" "${2}"
	echo "linked" "${1}" '->' "${2}"
}

pkg() {
	package="${1}"
	shift
	for action in "${@}"; do
		case "${action}" in
		"sync") curl -LO https://farajli.net/archive/"${package}".tar.gz ;;
		"unpack") tar xf "${package}".tar.gz ;;
		"compile") make -C "${package}" ;;
		"install") PREFIX="${BINDIR}" make -C "${package}" install ;;
		"font_install")	cp -r "${package}" "${FONTDIR}" ;;
		?)
			echo Invalid usage of pkg >&2
			return 1
		;;
		esac
	done
}

clean() { rm -rf -- *.tar.gz LiberationMono "${dwm_version}" "${dmenu_version}" "${slstatus_version}" "${st_version}"; }

create_dirs() {
	MAKEDIR "${BINDIR}"
	MAKEDIR "${CONFDIR}"
	MAKEDIR "${DATADIR}"
	MAKEDIR "${FONTDIR}"
}

install_bash()        { COPY config/bash/bashrc              "${BASHRC}";  }
install_dunst()       {	COPY config/dunst                    "${CONFDIR}"; }
install_lf()          {	COPY config/lf                       "${CONFDIR}"; }
install_mimeapps()    {	COPY config/mimeapps.list            "${CONFDIR}"; }
install_mpv()         {	COPY config/mpv                      "${CONFDIR}"; }
install_nsxiv()       {	COPY config/nsxiv                    "${CONFDIR}"; }
install_nvim()        {	COPY config/nvim                     "${CONFDIR}"; }
install_picom()       { COPY config/picom                    "${CONFDIR}"; }
install_qutebrowser() {	COPY config/qutebrowser              "${CONFDIR}"; }
install_sxiv()        {	COPY config/sxiv                     "${CONFDIR}"; }
install_vim()         {	COPY config/vim                      "${CONFDIR}"; }
install_x11()         {	COPY config/x11                      "${CONFDIR}"; }
install_zathura()     {	COPY config/zathura                  "${CONFDIR}"; }
install_wallpapers()  { COPY etc/wallpapers                  "${DATADIR}"; }
install_pacman()      { sudo cp etc/arch/pacman.conf         /etc;         }

install_git() {
	sed '/# signingkey = <to be set manually>/d' config/git/gitconfig > "${GITCONFIG}"
	printf '%s\n' \
	"#####################################################################" \
	"Warning: Git commit/tag signing is enabled but signingKey is not set." \
	"#####################################################################" \
	"Configure it manually using:" \
	"    gpg --list-secret-keys --keyid-format=long" \
	"    git config --global user.signingkey <YOUR_KEY_ID>" >&2
}

install_sites() {
	MAKEDIR                              "${CONFDIR}"/sites
	COPY config/sites/bookmarks.txt      "${CONFDIR}"/sites
}

install_zsh() {
	MAKEDIR                              "$(dirname "${ZCACHE}")"
	touch                                "${ZCACHE}"
	COPY config/zsh/zshrc                "${ZSHRC}"
}

install_shell() {
	COPY config/shell                    "${CONFDIR}"
	LINK "${CONFDIR}"/shell/profile      "${BASHPROFILE}"
	LINK "${CONFDIR}"/shell/profile      "${ZPROFILE}"
}

install_script_lib() { COPY scripts/slib "${BINDIR}"; }

install_cli_scripts() {
	install_script_lib
	COPY scripts/cli/* "${BINDIR}"
}

install_gui_scripts() {
	install_script_lib
	COPY scripts/gui/* "${BINDIR}"
}

install_liberationmono() { pkg "LiberationMono" sync unpack font_install; }
install_dwm()            { pkg "${dwm_version}" sync unpack install;      }
install_st()             { pkg "${st_version}" sync unpack install;       }
install_dmenu()          { pkg "${dmenu_version}" sync unpack install;    }
install_slstatus()       { pkg "${slstatus_version}" sync unpack install; }
