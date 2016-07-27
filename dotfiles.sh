#!/bin/bash

# ----------------------------------------------------------------------
# | Helper Functions                                                   |
# ----------------------------------------------------------------------

check_os() {

    declare -r OS_NAME="$(uname -s)"

    # Check if the OS is OS X and it is above a certain version
    if [ "$OS_NAME" == "Darwin" ]; then
        if [ $(compare_versions "$(sw_vers -productVersion)" "10.10") == "<" ]; then
            printf "Sorry, this script is intended only for OS X 10.10.0+."
            return 1
        else
            return 0
        fi

    # Check if the OS is Ubuntu
    else
        if [ "$OS_NAME" != "Linux" ] || [ ! -e "/etc/lsb-release" ]; then
            printf "Sorry, this script is intended only for OS X and Ubuntu!"
            return 1
        else
            return 0
        fi
    fi

}

compare_versions() {

    declare -a v1=(${1//./ })
    declare -a v2=(${2//./ })
    local i=""

    # Fill empty positions in v1 with zeros
    for (( i=${#v1[@]}; i<${#v2[@]}; i++ )); do
        v1[i]=0
    done

    for (( i=0; i<${#v1[@]}; i++ )); do

        # Fill empty positions in v2 with zeros
        if [[ -z ${v2[i]} ]]; then
            v2[i]=0
        fi

        if (( 10#${v1[i]} > 10#${v2[i]} )); then
            printf ">"
        fi

        if (( 10#${v1[i]} < 10#${v2[i]} )); then
            printf "<"
        fi

    done

    printf "="
}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

    # Ensure the OS is OS X or Ubuntu
    check_os || exit;

    # Ensure that the following actions are made
    # relative to the dotfiles directory root
    # http://mywiki.wooledge.org/BashFAQ/028
    cd "$(dirname "${BASH_SOURCE}")";

    source ./os/utils.sh

    ask_for_sudo

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_info "Create symbolic links"
    ./os/create_symbolic_links.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_info "Install applications"

    ask_for_confirmation "Do you want to install the applications/command line tools?"
    printf "\n"

    if answer_is_yes; then
        ./os/install_applications.sh
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_info "Install Prezto"

    ask_for_confirmation "Do you want to install Prezto?"
    printf "\n"

    if answer_is_yes; then
        ./os/install_prezto.sh
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_info "Set preferences"

    ask_for_confirmation "Do you want to set the custom preferences?"
    printf "\n"

    if answer_is_yes; then
        ./os/set_preferences.sh
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_info "Configure LAMP"

    ask_for_confirmation "Do you want to configure the LAMP stack?"
    printf "\n"

    if answer_is_yes; then
        ./os/configure_lamp.sh
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_info "Install Ruby Version Manager"

    ask_for_confirmation "Do you want to install RVM?"
    printf "\n"

    if answer_is_yes; then
        ./os/install_rvm.sh
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_info "Restart"

    ask_for_confirmation "Do you want to restart?"
    printf "\n"

    if answer_is_yes; then
        ./os/restart_computer.sh
    fi

}

main
