#!/bin/bash

declare -a FILES_TO_COPY=(
    "$HOME/.ssh"
    "$HOME/.gnupg"
    "$HOME/.zhistory"
    "$HOME/.gitconfig.local"
    "$HOME/Library/Application Support/Sublime Text 3/Packages/User/Preferences.sublime-settings"
    "/etc/hosts"
    "/usr/local/etc/php/5.4/php.ini"
    "/usr/local/etc/php/5.4/conf.d/ext-xdebug.ini"
    "/etc/apache2/httpd.conf"
    "/etc/apache2/extra/httpd-vhosts.conf"
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    declare -r MIGRATION_DIR="$HOME/migration"

    local sourceFile=""
    local targetFile=""
    local copyParams=""

    # Ensure that the following actions are made
    # relative to the dotfiles directory root
    # http://mywiki.wooledge.org/BashFAQ/028
    cd "$(dirname "${BASH_SOURCE}")";

    source ./bin/utils.sh

    # Prepare migration folder
    if [ -d "$MIGRATION_DIR" ]; then

        ask_for_confirmation "'$MIGRATION_DIR' already exists, do you want to overwrite it?"
        if answer_is_yes; then
            rm -r "$MIGRATION_DIR"
        else
            print_error "Backup interrupted" && exit
        fi

    fi

    mkd "$MIGRATION_DIR"

    # Copy files/folders

    for sourceFile in "${FILES_TO_COPY[@]}"; do

        targetFile="$MIGRATION_DIR/$(printf "%s" "$sourceFile" | sed "s/.*\/\(.*\)/\1/g")"
        copyParams=""

        if [ -e "$sourceFile" ]; then

            if [ -d "$sourceFile" ]; then
                copyParams="-r"
            fi
            execute "cp $copyParams $sourceFile $targetFile" "$sourceFile → $targetFile"

        else
            print_error "skipped $sourceFile as non existant"
        fi

    done

}

main
