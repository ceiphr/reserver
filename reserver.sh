#!/usr/bin/env bash

# Server space reserver.
# https://github.com/ceiphr/reserver/
# MIT License
# Copyright (c) 2022 Ari Birnbaum.
#
# A *very mild* contingency plan for servers that run out of space.
# Based on this great article by Brian Schrader:
# https://brianschrader.com/archive/why-all-my-servers-have-an-8gb-empty-file/

# Default Configuration
FILE_NAME=".reservation"           # The file that will be used to store the reservation.
DIRECTORY=$HOME                    # The directory where the reservation is stored.
RESERVATION_SIZE=5                 # The amount of space, in gigabytes, to reserve.
MAX_UNALLOCATED_SPACE_PERCENT=50   # The maximum percentage of unallocated space that can be reserved.
CONFIG_FILE="$HOME/.reserver.conf" # The configuration file.
LOCK_FILE="/tmp/reserver.lock"     # The lock file. Prevent multiple reservations at once.
DEBUG=0                            # Set to 1 to enable debug mode.

# Don't edit below this line.
# ----------------------------------------------------------------------------------------------------------------------

# For echo -e color support.
TXT_DEFAULT='\033[0m'
TXT_GREY='\033[2m'
TXT_GREEN='\033[0;32m'
TXT_RED='\033[0;31m'
TXT_BOLD='\033[1m'
TXT_UNBOLD_DIM='\033[0;2m'

# https://no-color.org/
if [[ -n "${NO_COLOR}" ]]; then
    TXT_DEFAULT='\033[0m'
    TXT_GREY='\033[0m'
    TXT_GREEN='\033[0m'
    TXT_RED='\033[0m'
fi

# In case the user quits the program in the critical section, we can
# simply unlock the section before exiting.
#
# If they interrupt the script as it's writing to the reservation file,
# the worst that could happen is that the reservation file is only partially
# full. The script will still function correctly.
handle_sigint() {
    if [ -f "$LOCK_FILE" ]; then
        rm "$LOCK_FILE"
    fi
    exit 1
}

trap 'handle_sigint' INT

# Check the default configuration is valid.
if [ $MAX_UNALLOCATED_SPACE_PERCENT -gt 100 ]; then
    echo -e "${TXT_RED}MAX_UNALLOCATED_SPACE_PERCENT must be less than 100. Exiting.${TXT_DEFAULT}" >&2
    exit 1
fi

# Check if the DEBUG environment variable is set.
if [[ -n "${RESERVER_DEBUG}" ]]; then
    DEBUG=1
fi

if [ $DEBUG -eq 1 ]; then
    echo -e "Debug mode ${TXT_GREEN}enabled${TXT_DEFAULT}. Reserver will not reserve space."
fi

help() {
    echo -e "$(
        cat <<-EOF
Usage: $(basename "$0") [options]
${TXT_GREY}
This script will reserve space on a server,
so, you can delete it later. 

Specifically, when your server runs out of space, you
can remove this reservation and the server will hopefully
have enough space to function again while you try to fix
whatever caused the issue.

By default, this script will create a ${TXT_BOLD}5GB${TXT_UNBOLD_DIM} reservation file 
in your home directory.
${TXT_DEFAULT}
Options:
    -r: Remove reservation.
    -s: The amount of space, in ${TXT_BOLD}gigabytes${TXT_DEFAULT}, to reserve. 
        ${TXT_GREY}Default is ${TXT_BOLD}$RESERVATION_SIZE${TXT_UNBOLD_DIM}. 
        Max is ${TXT_BOLD}$MAX_UNALLOCATED_SPACE_PERCENT%${TXT_UNBOLD_DIM} of the system's unallocated space.${TXT_DEFAULT}
    -f: The file name to use for the reservation.
        ${TXT_GREY}Default is '$FILE_NAME'.${TXT_DEFAULT}
    -d: The directory to use for the reservation. 
        ${TXT_GREY}Default is the user's home directory.${TXT_DEFAULT}
    -h: Print this help message.
EOF
    )"
}

# Tiago Lopo: https://stackoverflow.com/a/29436423/9264137
# This is used to ask the user for confirmation.
function yes_or_no {
    while true; do
        read -r -p "$* [y/N]: " yn
        case $yn in
        [Yy]*) return 0 ;;
        [Nn]*)
            echo "Aborted"
            return 1
            ;;
        esac
    done
}

# Mikkel: https://unix.stackexchange.com/a/206216/378978
# These two functions read and write to the config file.
# This way, if the user sets a custom location and or name
# for the reservation, we can remember it and remove
# it when asked.
read_config() {
    typeset -A config
    config=(
        [file_name]=$FILE_NAME
        [directory]=$DIRECTORY
    )

    while read -r line; do
        if echo "$line" | grep -F = &>/dev/null; then
            varname=$(echo "$line" | cut -d '=' -f 1)
            config[$varname]=$(echo "$line" | cut -d '=' -f 2-)
        fi
    done <"$CONFIG_FILE"

    FILE_NAME=${config[file_name]}
    DIRECTORY=${config[directory]}
}

write_config() {
    # In case the path is relative, make it absolute.
    absolute_dir=$(realpath "$DIRECTORY")

    echo "file_name=$FILE_NAME" >"$CONFIG_FILE"
    echo "directory=$absolute_dir" >>"$CONFIG_FILE"
}

# Remove the reservation file if it exists.
ret=0
remove() {
    # Config file remembers name and location of last reservation.
    # Once a reservation is removed, the config file is no longer needed.
    if [ -f "$CONFIG_FILE" ]; then
        read_config
        rm "$CONFIG_FILE"
    fi

    if [ -f "$DIRECTORY/$FILE_NAME" ]; then
        rm "$DIRECTORY/$FILE_NAME"
        echo -e "${TXT_GREEN}Reservation removed. Good luck!${TXT_DEFAULT}"
        ret=0
    else
        echo -e "${TXT_RED}No reservation file found. Exiting.${TXT_DEFAULT}" >&2
        ret=1
    fi

    return $ret
}

# Safety checks
version=5
if ((BASH_VERSINFO[0] < version)); then
    echo -e "${TXT_RED}This script was tested on GNU bash, version ${version}."
    echo -e "You're using an older version (v${BASH_VERSINFO[0]}).${TXT_DEFAULT}"
    message="Would you still like to continue?"
    yes_or_no "$message" || exit 1
fi

if [ "$EUID" -eq 0 ]; then
    echo -e "${TXT_RED}This script isn't supposed to be run as root.${TXT_DEFAULT}"
    message="Would you still like to continue?"
    yes_or_no "$message" || exit 1
    exit
fi

# Parse command line arguments.
configured=0
while getopts ':f:hd:s:r' OPTION; do
    case "$OPTION" in
    s)
        RESERVATION_SIZE="$OPTARG"
        echo -e "Reservation size set to ${TXT_BOLD}${RESERVATION_SIZE}GB${TXT_DEFAULT}."
        ;;
    f)
        FILE_NAME="$OPTARG"
        configured=1
        ;;
    d)
        DIRECTORY="$OPTARG"
        configured=1
        ;;
    r)
        remove
        exit $ret
        ;;
    h)
        help
        exit 0
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    ?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
done

if [ $configured -eq 1 ] && [ -f "$DIRECTORY/$FILE_NAME" ]; then
    echo -e "${TXT_RED}Configured file already exists. Will not overwrite. Exiting.${TXT_DEFAULT}" >&2
    exit 1
fi

# Acquire lock.
if [ -f "$LOCK_FILE" ]; then
    echo -e "${TXT_RED}A reservation is already in process. Exiting.${TXT_DEFAULT}" >&2
    exit 1
else
    touch "$LOCK_FILE"
fi

# Load config file if it exists.
if [ -f "$CONFIG_FILE" ]; then
    read_config
fi

if [ ! -d "$DIRECTORY" ] || [ ! -w "$DIRECTORY" ] ||
    [ "$DIRECTORY/$FILE_NAME" = "$CONFIG_FILE" ] ||
    [ "$DIRECTORY/$FILE_NAME" = "$LOCK_FILE" ]; then
    echo -e "${TXT_RED}Directory is not usable or does not exist. Exiting.${TXT_DEFAULT}" >&2

    if [ -f "$LOCK_FILE" ]; then
        rm "$LOCK_FILE"
    fi
    exit 1
fi

# If the user configured a file name or directory, remember that,
# so, it's not necessary to ask again when removing the reservation.
if [ $configured -eq 1 ] && [ ! -f "$CONFIG_FILE" ]; then
    touch "$CONFIG_FILE"
    write_config
fi

# Reservation was already made.
if [ -f "$DIRECTORY/$FILE_NAME" ]; then
    message="Reservation file already exists. Delete?"
    yes_or_no "$message" && remove

    if [ -f "$LOCK_FILE" ]; then
        rm "$LOCK_FILE"
    fi
    exit $ret
fi

if [ "$RESERVATION_SIZE" -le 0 ]; then
    echo -e "${TXT_RED}Reservation size is invalid. Exiting.${TXT_DEFAULT}" >&2

    if [ -f "$LOCK_FILE" ]; then
        rm "$LOCK_FILE"
    fi
    exit 1
fi

echo -e "Reserving ${TXT_BOLD}${RESERVATION_SIZE}GB${TXT_DEFAULT} of space..."

# Get the total unallocated space on the system.
TOTAL_UNALLOCATED_SPACE=$(df -BG / | grep -v "Filesystem" | awk '{print $4}' | tail -n 1)
if [ -z "$TOTAL_UNALLOCATED_SPACE" ]; then
    echo -e "${TXT_RED}Unable to determine total unused disk space. Exiting.${TXT_DEFAULT}" >&2

    if [ -f "$LOCK_FILE" ]; then
        rm "$LOCK_FILE"
    fi
    exit 1
fi

# Determine if the reservation is too large.
ALLOWED_UNALLOCATED_SPACE=$((${TOTAL_UNALLOCATED_SPACE::-1} * MAX_UNALLOCATED_SPACE_PERCENT / 100))
if [ "$ALLOWED_UNALLOCATED_SPACE" -lt "$RESERVATION_SIZE" ]; then
    echo -e "${TXT_RED}Not enough unused disk space. Exiting.${TXT_DEFAULT}" >&2

    if [ -f "$LOCK_FILE" ]; then
        rm "$LOCK_FILE"
    fi
    exit 1
fi

# Create reservation file.
CALCULATED_RESERVATION_SIZE=$((RESERVATION_SIZE * 1024))

if [ $DEBUG -eq 1 ]; then
    touch "$DIRECTORY/$FILE_NAME"
elif ! command -v fallocate &>/dev/null; then
    # Fallocate is not available. We're on a legacy system. Using dd instead.
    dd if=/dev/zero of="$DIRECTORY/$FILE_NAME" bs=1M count=$CALCULATED_RESERVATION_SIZE
else
    fallocate -l ${CALCULATED_RESERVATION_SIZE}M "$DIRECTORY/$FILE_NAME"
fi

# Release lock.
if [ -f "$LOCK_FILE" ]; then
    rm "$LOCK_FILE"
fi

echo -e "${TXT_GREEN}Reservation complete!${TXT_DEFAULT}"
