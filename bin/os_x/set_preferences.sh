#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")" && source "../utils.sh"

# ----------------------------------------------------------------------
# | iTerm2                                                               |
# ----------------------------------------------------------------------

set_iterm_preferences() {

    # Do not prompt on quit
    defaults write com.googlecode.iterm2 PromptOnQuit -bool false

    # Do not prompt on closing multiple sessions
    defaults write com.googlecode.iterm2 OnlyWhenMoreTabs -bool false

    # Do not check for test releases
    defaults write com.googlecode.iterm2 CheckTestRelease -bool false

}

# ----------------------------------------------------------------------
# | Dock                                                               |
# ----------------------------------------------------------------------

set_dock_preferences() {

    # Automatically hide or show the Dock
    defaults write com.apple.dock autohide -bool true

}

# ----------------------------------------------------------------------
# | Finder                                                             |
# ----------------------------------------------------------------------

set_finder_preferences() {

    # Use list view in all Finder windows by default
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # Set `Desktop` as the default location for new Finder windows
    defaults write com.apple.finder NewWindowTarget -string "PfHm"
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

    # Don't show recent tags
    defaults write com.apple.finder ShowRecentTags -bool false

    # Show path bar by default
    defaults write com.apple.finder ShowPathbar -bool true

}

# ----------------------------------------------------------------------
# | Keyboard                                                           |
# ----------------------------------------------------------------------

set_keyboard_preferences() {

    # Set the key repeat rate to fast
    defaults write NSGlobalDomain KeyRepeat -int 2

}

# ----------------------------------------------------------------------
# | UI/UX                                                              |
# ----------------------------------------------------------------------

set_ui_and_ux_preferences() {

    # Avoid creating `.DS_Store` files on network volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

    # Automatically quit the printer app once the print jobs are completed
    defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    declare -a PROCESSES_TO_TERMINATE=(
        "iTerm"
        "Dock"
        "Finder"
        "SystemUIServer"
        "cfprefsd"
    )

    execute "set_iterm_preferences" "iTerm2"
    execute "set_dock_preferences" "Dock"
    execute "set_finder_preferences" "Finder"
    execute "set_keyboard_preferences" "Keyboard"
    execute "set_ui_and_ux_preferences" "UI & UX"

    for i in ${!PROCESSES_TO_TERMINATE[*]}; do
	    killall "$i" &> /dev/null
    done

}

main
