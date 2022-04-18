#!/usr/bin/env bats

setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'

    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    PATH="$DIR/..:$PATH"
    FILE_NAME=".reservation" # The file that will be used to store the reservation.
    DIRECTORY=$HOME          # The directory where the reservation is stored.
}

@test "Default reservation file is created in the home directory." {
    run reserver.sh
    assert_output --partial 'Reserving 5GB of space...'
    assert_output --partial 'Reservation complete!'
}

teardown() {
    if [ -f "$HOME/.reserver.conf" ]; then
        rm $HOME/.reserver.conf
    fi

    if [ -f "$HOME/$FILE_NAME" ]; then
        rm $HOME/$FILE_NAME
    fi
}
