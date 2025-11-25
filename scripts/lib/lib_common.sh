#!/bin/sh

progname=$(basename "${0}")

# @FUNCTION: err
# @USAGE: [-x] <message> ...
# @DESCRIPTION:
# Print given messages to stderr line by line and exit with status 1.
#
# If "-x" is specified, suppress the program prefix (`program: `)
# from the output. Otherwise, the first line is prefixed with "program: ".
#
# This function is intended for fatal errors; it always exits the script.
# @EXAMPLE:
# err "Invalid usage" "Try '${progname} -h' for help."
err() {
	if [ "${1}" != "-x" ]; then
		printf "%s: " "${progname}"
	else
		shift
	fi

	for line in "${@}"; do
		echo "${line}" >&2
	done
	exit 1
}

# @FUNCTION: invalid_use
# USAGE: [-h]
# @DESCRIPTION:
# Output a usage error message. If `-h` is not specified output:
# 	"<program>: Invalid usage "
# 	"Try 'program -h' for help."
# else output only:
# 	"Try 'program -h' for help."

invalid_use() {
	[ "${1}" = "-h" ] && err -x "Try '${progname} -h' for help."
	err "Invalid usage" "Try '${progname} -h' for help."
}

# @FUNCTION: check_program
# USAGE: <command> [error-msg]
# @DESCRIPTION:
# Check if command exists on the system.
# If not, print an error message to stderr and exit with status 1.
# The default error message is "`command` must be installed"
# but can optionally be overwritten.
#
# @EXAMPLE:
# Check if pulseaudio is installed.
#
# check_program "pactl" "pulseaudio must be installed"

check_program() {
	command -v "${1}" > /dev/null 2>&1 && return 0
	[ -n "${2}" ] && err "${2}"
	err "${1} must be installed"
}

# @FUNCTION: get_random_filename
# @USAGE: get_random_filename [parentdir] <extension>
# @DESCRIPTION:
# Write a random file path to stdout, under parentdir, (if provided else under /tmp) with the extension.
#
# @EXAMPLE:
# Get a filepath in the `/var` directory with the extension `.png`
#
# get_random_filename .png /var

get_random_filename() {
	[ "${#}" -eq 2 ] && parentdir="${2}" || parentdir="/tmp"

	extension="${1}"

	echo "${parentdir}/$(date '+%b%d::%H%M%S')${extension}"
}

# @FUNCTION: run
# @USAGE: [--reload-status] [--reload-compositor] [--success-notify <msg>] [--failure-notify <msg>] <command> [success-msg] [failure-msg]
# @DESCRIPTION:
# Safely execute a simple shell command, print optional success/failure messages,
# and optionally reload the status bar or restart the compositor.
#
# Success messages are printed to stdout; failure messages are printed to stderr.
# Optional desktop notifications can be sent using --success-notify and --failure-notify.
# Command output is not suppressed.
#
# Options:
#   --reload-status        Reload the status bar (via `slreload`).
#   --reload-compositor    Restart the compositor (kills and restarts `picom`).
#   --success-notify <msg> Send a desktop notification on success.
#   --failure-notify <msg> Send a desktop notification on failure.
#
# Restrictions:
#   - Does NOT use `eval`; only simple commands and arguments are supported.
#   - Shell operators like `&&`, `||`, `|`, `>`, `>>`, etc. will NOT work.
#   - This design prevents unintended execution and makes the function safe in scripts.
#
# Return value:
#   Exits with 0 if the command succeeds, 1 otherwise.
#
# @EXAMPLES:
#   # Run xwallpaper and print the image path on success
#   run "xwallpaper --zoom ${image}" "${image}"
#
#   # Restart compositor and show a success message
#   run --reload-compositor "xwallpaper --zoom ${image}" "Wallpaper updated" "Wallpaper failed"
#
#   # With notification hooks
#   run --success-notify "Wallpaper set" \
#       --failure-notify "Wallpaper failed" \
#       "xwallpaper --zoom ${image}" "Wallpaper updated" "Wallpaper failed"

run() {
	no_exit=0
	reload_status=0
	reload_compositor=0

	[ "${1}" = "--no-exit" ]           && no_exit=1           && shift
    	[ "${1}" = "--reload-status" ]     && reload_status=1     && shift
    	[ "${1}" = "--reload-compositor" ] && reload_compositor=1 && shift

	trap '
		[ "${reload_status}" -eq 1 ] && status_handle reload
		[ "${reload_compositor}" -eq 1 ] && compositor_handle start
	' EXIT

	[ "${reload_compositor}" -eq 1 ] && compositor_handle stop

	eval "${@}"
	[ "${no_exit}" -eq 1 ] || exit "${?}"
}
