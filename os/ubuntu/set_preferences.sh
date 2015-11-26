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

# ----------------------------------------------------------------------
# | System                                                             |
# ----------------------------------------------------------------------

set_system_settings() {

	local LDMPATH="/etc/lightdm/lightdm.conf.d"

	# Create a configuration file to disable guest login on Ubuntu
	sudo mkdir -p $LDMPATH && \
		printf "[SeatDefaults]\nallow-guest=false" | sudo tee "$LDMPATH/50-allow-guest.conf"

}

# ----------------------------------------------------------------------
# | UI/UX                                                              |
# ----------------------------------------------------------------------

set_ui_and_ux_settings() {

    # Hide the bluetooth and volume icons from the menu bar
    gsettings set com.canonical.indicator.bluetooth visible false && \

    # Hide the battery icon from the menu bar when the battery is not in use
    gsettings set com.canonical.indicator.power icon-policy "charge" && \
    gsettings set com.canonical.indicator.power show-time false && \

    # Set date format in the menu bar
    gsettings set com.canonical.indicator.datetime show-calendar true && \
    gsettings set com.canonical.indicator.datetime show-clock true && \
    gsettings set com.canonical.indicator.datetime show-date true && \
    gsettings set com.canonical.indicator.datetime show-day true && \
    gsettings set com.canonical.indicator.datetime show-year false && \
    gsettings set com.canonical.indicator.datetime time-format "24-hour" && \

    # Hide keyboard switcher
    gsettings set com.canonical.indicator.keyboard visible false && \

    # Auto-hide launcher
    gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-hide-mode 1 && \

    # Remove "Show desktop" icon from switcher
    gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ disable-show-desktop true

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    execute "set_privacy_settings" "Privacy"
    execute "set_system_settings" "System"
    execute "set_ui_and_ux_settings" "UI & UX"
}

main
