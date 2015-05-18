#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")" && source "../utils.sh"

# Homebrew Formulae
# https://github.com/Homebrew/homebrew

declare -r -a HOMEBREW_FORMULAE=(
    "caskroom/cask/brew-cask"
    "curl --with-openssl"
    "wget --enable-iri"
    "git"
    "mariadb"
    "htop-osx"
    "gifsicle"
    "optipng"
    "vim --override-system-vi"
)

# Homebrew Php Formulae
# https://github.com/Homebrew/homebrew-php

declare -r -a HOMEBREW_PHP_FORMULAE=(
    "php54"
    "php54-xdebug"
    "composer"
)

# Homebrew Casks
# https://github.com/caskroom/homebrew-cask

declare -r -a HOMEBREW_CASKS=(
    # browsers
    "google-chrome"
    "firefox"
    "opera"

    # daily
    "alfred"

    # development
    "iterm2"
    "phpstorm"
    "atom"
    "brackets"
    "visual-studio-code"
    "imagealpha"
    "imageoptim"
    "filezilla"

    # communication
    "skype"
    "slack"

    # others
    "spotify"
    "qbittorrent"
    "vlc"
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew_install() {

    declare -r -a FORMULAE=("${!1}"); shift;
    declare -r CMD="$1"

    for i in ${!FORMULAE[*]}; do
        tmp="${FORMULAE[$i]}"
        [ $(brew "$CMD" list "$tmp" &> /dev/null; printf $?) -eq 0 ] \
            && print_success "$tmp" \
            || execute "brew $CMD install $tmp" "$tmp"
    done

}

brew_tap() {

    declare -r REPOSITORY="$1"

    brew tap "$REPOSITORY" &> /dev/null

    [ "$(brew tap | grep "$REPOSITORY" &> /dev/null; printf $?)" -eq 0 ] \
        && (print_success "brew tap ($REPOSITORY)"; return 0) \
        || (print_error "brew tap ($REPOSITORY)"; return 1)

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    local i="", tmp=""

    # XCode Command Line Tools
    if [ $(xcode-select -p &> /dev/null; printf $?) -ne 0 ]; then
        xcode-select --install &> /dev/null

        # Wait until the XCode Command Line Tools are installed
        while [ $(xcode-select -p &> /dev/null; printf $?) -ne 0 ]; do
            sleep 5
        done
    fi

    print_success "XCode Command Line Tools\n"

    # Homebrew
    if [ $(cmd_exists "brew") -eq 1 ]; then
        printf "\n" | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        #  └─ simulate the ENTER keypress
        print_result $? "brew"
    fi

    if [ $(cmd_exists "brew") -eq 0 ]; then

        execute "brew update" "brew (update)"
        execute "brew upgrade --all" "brew (upgrade)"
        execute "brew cleanup" "brew (cleanup)"
        printf "\n"

        brew_install "HOMEBREW_FORMULAE[@]"
        printf "\n"

        brew_tap "homebrew/dupes" \
            && brew_tap "homebrew/versions" \
            && brew_tap "homebrew/homebrew-php" \
            && brew_install "HOMEBREW_PHP_FORMULAE[@]"
        printf "\n"

        brew_tap "caskroom/cask" \
            && brew_install "HOMEBREW_CASKS[@]" "cask"
        printf "\n"

    fi

}

main
