#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")" && source "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    # Check if `rvm` is installed
    if [ $(cmd_exists "rvm") -eq 0 ]; then
        print_error "RVM is already installed.\n"
        exit 0
    fi

    # Install gpg key
    execute "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3" "Install RVM gpg key"

    # Install latest stable rvm
    \curl -sSL https://get.rvm.io | bash -s stable --ignore-dotfiles &> /dev/null
    print_result $? "Install Ruby Version Manager (RVM)"

}

main
