#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")" && source "../utils.sh"

declare -a APT_PACKAGES=(
    # System
    "curl"
    "git"
    "vim"
    "htop"
    "terminator"

    # Lamp
    "php5"
    "mariadb-server"
    "php5-mysql"
    "php5-curl"
    "php5-xdebug"

    # Browsers
    "google-chrome-stable"
    "opera-stable"

    # Development
    "filezilla"
    "sublime-text-installer"

    # Other
    "qbittorrent"
    "unity-tweak-tool"
    "vlc"

)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_key() {
    wget -qO - "$1" | sudo apt-key add - &> /dev/null
    #     │└─ write output to file
    #     └─ don't show output
}

add_ppa() {
    sudo add-apt-repository -y ppa:"$1" &> /dev/null
}

add_software_sources() {

    # Sublime Text 3
    [ $(cmd_exists "subl") -eq 1 ] \
        && add_ppa "webupd8team/sublime-text-3"

    # Google Chrome
    [ $(cmd_exists "google-chrome") -eq 1 ] \
        && add_key "https://dl-ssl.google.com/linux/linux_signing_key.pub" \
        && add_source_list \
                "http://dl.google.com/linux/chrome/deb/ stable main" \
                "google-chrome.list"

    # Opera
    [ $(cmd_exists "opera") -eq 1 ] \
        && add_key "http://deb.opera.com/archive.key" \
        && add_source_list \
                "http://deb.opera.com/opera-stable/ stable non-free" \
                "opera.list"

}

add_source_list() {
    sudo sh -c "printf 'deb $1' >> '/etc/apt/sources.list.d/$2'"
}

install_package() {
    local q="${2:-$1}"

    if [ $(cmd_exists "$q") -eq 1 ]; then
        execute "sudo apt-get install --allow-unauthenticated -qqy $1" "$1"
        #                                      suppress output ─┘│
        #            assume "yes" as the answer to all prompts ──┘
    fi
}

remove_unneeded_packages() {

    # Remove packages that were automatically installed to satisfy
    # dependencies for other other packages and are no longer needed
    execute "sudo apt-get autoremove -qqy" "autoremove"

}

update_and_upgrade() {

    # Resynchronize the package index files from their sources
    execute "sudo apt-get update -qqy" "update"

    # Install the newest versions of all packages installed
    execute "sudo apt-get upgrade -qqy" "upgrade"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    local i=""

    add_software_sources
    update_and_upgrade

    printf "\n"

    for i in ${!APT_PACKAGES[*]}; do
        install_package "${APT_PACKAGES[$i]}"
    done

    printf "\n"

    update_and_upgrade
    remove_unneeded_packages

}

main
