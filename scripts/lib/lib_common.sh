#!/bin/sh

progname=$(basename "${0}")

# Print each message to stderr, then exit with status 1.
#
# If the first argument is "-x", the program name prefix is not added.
# Otherwise, the first printed line starts with "program: ".
#
# Example:
#   err "Invalid usage" "Try '${progname} -h' for help."

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

# Print a usage error message.
#
# Without "-h", it prints:
#   "<program>: Invalid usage"
#   "Try 'program -h' for help."
#
# With "-h", it prints only:
#   "Try 'program -h' for help."

invalid_use() {
	[ "${1}" = "-h" ] && err -x "Try '${progname} -h' for help."
	err "Invalid usage" "Try '${progname} -h' for help."
}

# Check if a command exists.
# If it does not, print an error message to stderr and exit with status 1.
#
# The default message is: "`command` must be installed"
# You can override it with a custom message.
#
# Example:
#   check_program "pactl" "pulseaudio must be installed"

check_program() {
	command -v "${1}" > /dev/null 2>&1 && return 0
	[ -n "${2}" ] && err "${2}"
	err "${1} must be installed"
}

# Print a random file path to stdout.
# The file will be placed in the given directory, or in /tmp if none is provided.
# The last argument is the file extension.
#
# Example:
#   get_random_filename /var .png

get_random_filename() {
	[ "${#}" -eq 2 ] && parentdir="${2}" || parentdir="/tmp"

	extension="${1}"

	echo "${parentdir}/$(date '+%b%d::%H%M%S')${extension}"
}

# Run a command with optional flags that control exit behavior
# and automatic reload actions.
#
# Options must appear first and in the order listed:
#   --no-exit
#   --reload-status
#   --reload-compositor
#
# Supported options:
#   --no-exit
#       Do not exit after running the command. Normally, the
#       function exits with the command's status.
#
#   --reload-status
#       After the command finishes, call: status_handle reload
#
#   --reload-compositor
#       Before running the command, stop the compositor.
#       After the command finishes, start it again.
#
# After the options, the remaining arguments are treated as the
# command to run (passed through eval).
#
# Example:
#   run --reload-status --reload-compositor my_command --flag

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
