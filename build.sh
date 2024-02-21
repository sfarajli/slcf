#!/bin/sh

as_sudo(){
	SUDO=sudo 
	$@
	SUDO=""
}

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
home_dir="$HOME"

dotfiles_install() {
	[ -d $config_dir ] || mkdir -v $config_dir
	COPY ./src/dotfiles/*  "$config_dir"
	COPY ./src/dotfiles/zsh/zshrc "$home_dir"/.zshrc
	COPY ./src/dotfiles/Xresources "$home_dir"/.Xresources
}

scripts_install() {
	[ -d /usr/local/bin ] || sudo mkdir -v /usr/local/bin
	as_sudo COPY ./src/scripts/* /usr/local/bin/
}

archlinux_install() {
	as_sudo COPY ./src/distros/arch-linux/pacman.conf /etc
}

profile_install() {
	[ -d /etc/profile.d ] || { sudo mkdir /etc/profile.d && printf "/etc/profile.d directory created" ; }
	as_sudo COPY ./src/etc/profile.d/theion.sh /etc/profile.d || echo "Couldn't install to /etc/profile.d"
}

help() {
	 cat <<EOF
Usage $0:
	-d		Install dotfiles to .config
	-s		Install scripts to /usr/local/bin
	-ds		Install scripts and dotfiles

	--profile	Install profile files
	--archlinux	Install Arch linux specific files
	--force		Overwrite the existing files
	--all		Install everything (except Arch linux specific files)
EOF
exit 2
}

[ $# = 0 ] && help 

for argument in $@;do
	if [ $argument = "--force" ];then
		COPY(){ $SUDO cp -r $@; }
		break
	fi
	COPY(){ $SUDO cp -nr $@; }
done

for argument in $@;do
	case "$argument" in
		"-d") dotfiles_install;;

		"-s")
			scripts_install;;

		"-ds")
			dotfiles_install
			scripts_install
			;;

		"--profile") 
			profile_install;;

		"--archlinux") 
			archlinux_install
			;;
				
		"--all") 
			dotfiles_install
			scripts_install
			profile_install
			;;

		"--force");;

		*) help ;;
	esac
done
