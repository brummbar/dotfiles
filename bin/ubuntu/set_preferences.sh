#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")" && source "../utils.sh"

# ----------------------------------------------------------------------
# | Privacy                                                            |
# ----------------------------------------------------------------------

set_privacy_settings() {

    # Turn off "Remote Search" so that search
    # terms in Dash don't get sent over the internet
    gsettings set com.canonical.Unity.Lenses remote-content-search 'none' && \

    # Disable Dash's "More suggestions" section
    gsettings set com.canonical.Unity.ApplicationsLens display-available-apps false

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    execute "set_privacy_settings" "Privacy"
}

main
