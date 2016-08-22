#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")" && source "../utils.sh"

# Homebrew Formulae
# https://github.com/Homebrew/homebrew

declare -r -a HOMEBREW_FORMULAE=(
    "caskroom/cask/brew-cask"
    "coreutils"
    "curl --with-openssl"
    "wget --enable-iri"
    "git --without-completions"
    "mariadb"
    "htop-osx"
    "vim --override-system-vi"
    "node"
)

# Homebrew Php Formulae
# https://github.com/Homebrew/homebrew-php

declare -r -a HOMEBREW_PHP_FORMULAE=(
    "php56 --without-ldap"
    "php56-xdebug"
    "php56-memcached"
    # "php70 --without-ldap"
    # "php70-xdebug"
    # "php70-opcache"
    "composer"
    "drush"
    "drupal-code-sniffer"
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
    "imagealpha"
    "imageoptim"
    "filezilla"
    "virtualbox"
    "java"
    "phpstorm"

    # optional editors
    # "atom"
    # "brackets"
    # "visual-studio-code"

    # communication
    "skype"
    "slack"

    # others
    "spotify"
    "qbittorrent"
    "vlc"
)

# Homebrew Alternate Casks
# https://github.com/caskroom/homebrew-versions

declare -r -a HOMEBREW_ALTERNATE_CASKS=(
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew_install() {

    declare -r -a FORMULAE=("${!1}"); shift;
    declare -r CMD="$1"

    local i="", tmp=""

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

    if ! xcode-select --print-path &> /dev/null; then

        # Prompt user to install the XCode Command Line Tools
        xcode-select --install &> /dev/null

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Wait until the XCode Command Line Tools are installed
        until xcode-select --print-path &> /dev/null; do
            sleep 5
        done

        print_result $? 'Install XCode Command Line Tools'

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Point the `xcode-select` developer directory to
        # the appropriate directory from within `Xcode.app`
        # https://github.com/alrra/dotfiles/issues/13

        sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
        print_result $? 'Make "xcode-select" developer directory point to Xcode'

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Prompt user to agree to the terms of the Xcode license
        # https://github.com/alrra/dotfiles/issues/10

        sudo xcodebuild -license
        print_result $? 'Agree with the XCode Command Line Tools licence'

    fi

    print_result $? 'XCode Command Line Tools'

    # Homebrew
    if ! cmd_exists "brew"; then
        printf "\n" | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        #  └─ simulate the ENTER keypress
        print_result $? "brew"
    fi

    if cmd_exists "brew"; then

        execute "brew update" "brew (update)"
        execute "brew upgrade --all" "brew (upgrade)"
        execute "brew cleanup" "brew (cleanup)"
        printf "\n"

        brew_install "HOMEBREW_FORMULAE[@]"
        printf "\n"

        brew_tap "homebrew/dupes" \
            && brew_tap "homebrew/versions" \
            && brew_tap "homebrew/php" \
            && brew_install "HOMEBREW_PHP_FORMULAE[@]"
        printf "\n"

        brew_tap "caskroom/cask" \
            && brew_install "HOMEBREW_CASKS[@]" "cask"
        printf "\n"

        # Uncomment this part if any alternate casks are needed.
        # brew_tap "caskroom/versions" \
        #     && brew_install "HOMEBREW_ALTERNATE_CASKS[@]" "cask"
        # printf "\n"

    fi

}

main
