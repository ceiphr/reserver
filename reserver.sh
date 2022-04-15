#!/usr/bin/env bash

# Server space reserver.
# https://github.com/ceiphr/reserver
# MIT License
# Copyright (c) 2022 Ari Birnbaum.
#
# A *very mild* contingency plan for servers that run out of space.

# Default Configuration
FILE_NAME=".reservation"         # The file that will be used to store the reservation.
DIRECTORY=$HOME                  # The directory where the reservation is stored.
RESERVATION_SIZE=5               # The amount of space, in gigabytes, to reserve.
MAX_UNALLOCATED_SPACE_PERCENT=50 # The maximum percentage of unallocated space that can be reserved.
LOCK_FILE="/tmp/reserver.lock"   # The lock file. Prevent multiple reservations at once.

# Don't edit below this line.

# TODO Ensure lock is locked/released when appropriate (e.g. in remove()).

# For echo -e color support.
TXT_DEFAULT='\033[0m'
TXT_GREEN='\033[0;32m'
TXT_RED='\033[0;31m'

# For here-doc color support.
TXT_WHITE=$(tput setaf 252)
TXT_GREY=$(tput setaf 8)

help() {
    cat <<-EOF
Usage: $(basename "$0") [options]
${TXT_GREY}
This script will reserve space on a server,
so you can delete it later. 

Specifically, when your server runs out of space, you
can remove this reservation and the server will hopefully
have enough space to function again while you try to fix
whatever caused the issue.

By default, will create a 5GB reservation file 
in your home directory.
${TXT_WHITE}
Options:
    -r: Removes reservation.
    -s: The amount of space, in gigabytes, to reserve. 
        ${TXT_GREY}Default is $RESERVATION_SIZE. 
        Max is $MAX_UNALLOCATED_SPACE_PERCENT% of the system's unallocated space.${TXT_WHITE}
    -f: The file name to use for the reservation.
        ${TXT_GREY}Default is '$FILE_NAME'.${TXT_WHITE}
    -d: The directory to use for the reservation. 
        ${TXT_GREY}Default is the user's home directory.${TXT_WHITE}
    -h: Print this help message.
EOF
}

# Tiago Lopo: https://stackoverflow.com/a/29436423/9264137
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

# Remove the reservation file if it exists.
remove() {
    if [ -f "$DIRECTORY/$FILE_NAME" ]; then
        rm "$DIRECTORY/$FILE_NAME"

        echo -e "${TXT_GREEN}Reservation removed. Good luck!${TXT_DEFAULT}"

        exit 0
    else
        echo -e "${TXT_RED}No reservation file found.${TXT_DEFAULT}"
        exit 1
    fi

    if [ -f "$LOCK_FILE" ]; then
        rm "$LOCK_FILE"
    fi
}

while getopts ':f:hn:d:s:rc' OPTION; do
    case "$OPTION" in
    r)
        remove
        ;;
    s)
        RESERVATION_SIZE="$OPTARG"
        ;;
    f)
        FILE_NAME="$OPTARG"
        echo "Using file: $FILE_NAME"
        ;;
    d)
        DIRECTORY="$OPTARG"
        echo "Using directory: $DIRECTORY"
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

# Acquire lock.
if [ -f "$LOCK_FILE" ]; then
    echo -e "${TXT_RED}A reservation was already in process. Exiting.${TXT_DEFAULT}"
    exit 1
else
    touch "$LOCK_FILE"
fi

# Reservation was already made.
if [ -f "$DIRECTORY/$FILE_NAME" ]; then
    message="Reservation file already exists. Delete?"
    yes_or_no "$message" && remove

    if [ -f "$LOCK_FILE" ]; then
        rm "$LOCK_FILE"
    fi
    exit 0
fi

echo -e "${TXT_GREEN}Reserving $RESERVATION_SIZE GB of space...${TXT_DEFAULT}"

# Get the total unallocated space on the system.
TOTAL_UNALLOCATED_SPACE=$(df -BG / | grep -v "Filesystem" | awk '{print $4}' | tail -n 1)
if [ -z "$TOTAL_UNALLOCATED_SPACE" ]; then
    echo -e "${TXT_RED}Unable to determine total unused disk space. Exiting.${TXT_DEFAULT}"
    exit 1
fi

# Determine if the reservation is too large.
ALLOWED_UNALLOCATED_SPACE=$((${TOTAL_UNALLOCATED_SPACE::-1} * MAX_UNALLOCATED_SPACE_PERCENT / 100))
if [ "$ALLOWED_UNALLOCATED_SPACE" -lt "$RESERVATION_SIZE" ]; then
    echo -e "${TXT_RED}Not enough unused disk space. Exiting.${TXT_DEFAULT}"
    exit 1
fi

# Create reservation file.
CALCULATED_RESERVATION_SIZE=$((RESERVATION_SIZE * 1024))

if ! command -v fallocate &>/dev/null; then
    # Fallocate is not available. We're on a legacy system. Using dd instead.
    dd if=/dev/zero of="$DIRECTORY/$FILE_NAME" bs=1M count=$CALCULATED_RESERVATION_SIZE
else
    fallocate -l $CALCULATED_RESERVATION_SIZE "$DIRECTORY/$FILE_NAME"
fi

# Release lock.
if [ -f "$LOCK_FILE" ]; then
    rm "$LOCK_FILE"
fi

echo -e "${TXT_GREEN}Reservation complete!${TXT_DEFAULT}"
