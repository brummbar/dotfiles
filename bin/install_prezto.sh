#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")" && source "utils.sh"

declare -a FILES_TO_SYMLINK=(
    "zlogin"
    "zlogout"
    "zpreztorc"
    "zprofile"
    "zshenv"
    "zshrc"
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    declare -r BASE16_DIR="$HOME/.base16"

    local i=""
    local sourceFile=""
    local targetFile=""

    # Check if `Git` is installed
    if [ $(cmd_exists "git") -eq 1 ]; then
        print_error "Git is required, please install it!\n"
        exit 1
    fi

    # Clone base16-vim
    if [ ! -d "$BASE16_DIR/base16-vim" ]; then

        git clone https://github.com/chriskempson/base16-vim.git "$BASE16_DIR/base16-vim" &> /dev/null
        print_result $? "Clone base16-vim" "true"

    fi

    # Clone base16-shell
    if [ ! -d "$BASE16_DIR/base16-shell" ]; then

        git clone https://github.com/chriskempson/base16-shell.git "$BASE16_DIR/base16-shell" &> /dev/null
        print_result $? "Clone base16-shell" "true"

    fi

    # Clone Brummbar prezto
    if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then

        git clone --recursive https://github.com/brummbar/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" &> /dev/null
        print_result $? "Clone Brummbar prezto" "true"

    fi

    # Create symlinks for prezto
    for i in ${FILES_TO_SYMLINK[@]}; do

        sourceFile="${ZDOTDIR:-$HOME}/.zprezto/runcoms/$i"
        targetFile="${ZDOTDIR:-$HOME}/.$i"

        if [ -e "$targetFile" ]; then
            if [ "$(readlink "$targetFile")" != "$sourceFile" ]; then

                ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
                if answer_is_yes; then
                    execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
                else
                    print_error "$targetFile → $sourceFile"
                fi

            else
                print_success "$targetFile → $sourceFile"
            fi
        else
            execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
        fi

    done

    # Symlink the matching vim color
    mkdir -p "$HOME/.vim/colors"
    sourceFile="$BASE16_DIR/base16-vim/colors/base16-tomorrow.vim"
    targetFile="$HOME/.vim/colors/base16-tomorrow.vim"
    execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"

}

main
