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
    declare -r PREZTO_DIR="${ZDOTDIR:-$HOME}/.zprezto"
    declare -r OS="$(get_os)"

    local i=""
    local sourceFile=""
    local targetFile=""

    # Check if `Git` is installed
    if ! cmd_exists "git"; then
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
    if [ ! -d $PREZTO_DIR ]; then

        git clone --recursive https://github.com/brummbar/prezto.git $PREZTO_DIR &> /dev/null
        print_result $? "Clone Brummbar prezto" "true"

    fi

    # Create symlinks for prezto
    for i in ${FILES_TO_SYMLINK[@]}; do

        sourceFile="${ZDOTDIR:-$HOME}/.zprezto/runcoms/$i"
        targetFile="${ZDOTDIR:-$HOME}/.$i"

        symlink $targetFile $sourceFile

    done

    # Symlink the matching vim color
    mkdir -p "$HOME/.vim/colors"
    symlink "$HOME/.vim/colors/base16-tomorrow-night.vim" "$BASE16_DIR/base16-vim/colors/base16-tomorrow-night.vim"

    # Install iTerm2/Terminator color schemes based on os.
    if [ "$OS" == "osx" ]; then

        # todo: fetch profile
        echo "nothing" &> /dev/null

    elif [ "$OS" == "ubuntu" ]; then

        sourceFile="$(cd .. && pwd)/terminator/config"
        targetFile="$HOME/.config/terminator/config"

        symlink $targetFile $sourceFile

    fi

}

main
