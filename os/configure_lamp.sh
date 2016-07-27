#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")" && source "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    declare -r OS="$(get_os)"

    if [ "$OS" == "osx" ]; then
        ./os_x/configure_lamp.sh
    elif [ "$OS" == "ubuntu" ]; then
        ./ubuntu/configure_lamp.sh
    fi

}

main
