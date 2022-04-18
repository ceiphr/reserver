#!/usr/bin/env bats

setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    load 'test_helper/bats-file/load'

    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    PATH="$DIR/..:$PATH"
    FILE_NAME=".reservation" # The file that will be used to store the reservation.
    DIRECTORY=$HOME          # The directory where the reservation is stored.
}

@test "Default reservation file is created." {
    run reserver.sh
    [ "$status" -eq 0 ]
    assert_output --partial 'Reservation complete!'
    assert_file_exists "$DIRECTORY/$FILE_NAME"
    assert_file_not_exists "$DIRECTORY/.reserver.conf"
    assert_file_not_exists "/tmp/reserver.lock"
}

@test "Reservation size is negative." {
    run reserver.sh -s -1
    [ "$status" -eq 1 ]
    assert_output --partial 'Reservation size is invalid. Exiting.'
    assert_file_not_exists "$DIRECTORY/$FILE_NAME"
    assert_file_not_exists "$DIRECTORY/.reserver.conf"
    assert_file_not_exists "/tmp/reserver.lock"
}

@test "Reservation is too large." {
    run reserver.sh -s 1000000000
    [ "$status" -eq 1 ]
    assert_output --partial 'Not enough unused disk space. Exiting.'
    assert_file_not_exists "$DIRECTORY/$FILE_NAME"
    assert_file_not_exists "$DIRECTORY/.reserver.conf"
    assert_file_not_exists "/tmp/reserver.lock"
}

@test "Help message printed." {
    run reserver.sh -h
    [ "$status" -eq 0 ]
    assert_output --partial 'Usage: reserver.sh [options]'
}

# Directory tests.

@test "Directory doesn't exist." {
    run reserver.sh -d /tmp/non-existent-directory
    [ "$status" -eq 1 ]
    assert_output --partial 'Directory is not usable or does not exist. Exiting.'
    assert_file_not_exists "$DIRECTORY/$FILE_NAME"
    assert_file_not_exists "$DIRECTORY/.reserver.conf"
    assert_file_not_exists "/tmp/reserver.lock"
}

@test "Directory isn't writable." {
    run reserver.sh -d /opt
    [ "$status" -eq 1 ]
    assert_output --partial 'Directory is not usable or does not exist. Exiting.'
    assert_file_not_exists "$DIRECTORY/$FILE_NAME"
    assert_file_not_exists "$DIRECTORY/.reserver.conf"
    assert_file_not_exists "/tmp/reserver.lock"
}

@test "Directory is used by the script for settings (config)." {
    run reserver.sh -d $HOME/.reserver.conf
    [ "$status" -eq 1 ]
    assert_output --partial 'Directory is not usable or does not exist. Exiting.'
    assert_file_not_exists "$DIRECTORY/$FILE_NAME"
    assert_file_not_exists "$DIRECTORY/.reserver.conf"
    assert_file_not_exists "/tmp/reserver.lock"
}

@test "Directory is used by the script for settings (lock)." {
    run reserver.sh -d /tmp/.reserver.lock
    [ "$status" -eq 1 ]
    assert_output --partial 'Directory is not usable or does not exist. Exiting.'
}

teardown() {
    if [ -f "$HOME/.reserver.conf" ]; then
        rm $HOME/.reserver.conf
    fi

    if [ -f "/tmp/reserver.lock" ]; then
        rm /tmp/reserver.lock
    fi
    
    if [ -f "$HOME/$FILE_NAME" ]; then
        rm $HOME/$FILE_NAME
    fi
}
