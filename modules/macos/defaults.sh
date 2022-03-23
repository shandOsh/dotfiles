#! /usr/bin/env bash

OPERATION_READ="read"
OPERATION_WRITE="write"
OPERATION_VERIFY="verify"

function cmd_defaults() {
    local verify=0
    local operation="${1}"
    local setting_desc="${2}"
    local setting_name="${3}"
    local setting_value="${4}"

    if [[ "${operation}" == "${OPERATION_VERIFY}" ]]; then
        operation="${OPERATION_READ}"
        verify=1
    fi

    echo "  › ${setting_desc}"
    echo "    › defaults \"${operation}\" ${setting_name} \"${setting_value}\""

    local cmd_output="$(defaults "${operation}" ${setting_name} "${setting_value}" 2>&1)"

    if [[ "${verify}" -eq 1 ]]; then
        local cmd_output_canonized="${cmd_output}"

        if [[ "${setting_value}" == "false" ]] && [[ "${cmd_output}" == "0" ]]; then
            cmd_output_canonized="false"
        elif [[ "${setting_value}" == "true" ]] && [[ "${cmd_output}" == "1" ]]; then
            cmd_output_canonized="true"
        fi

        if [[ "${cmd_output_canonized}" != "${setting_value}" ]]; then
            ansi --red "      › current: [${cmd_output_canonized}]"
            ansi --red "      › should be: [${setting_value}]"
        fi
    else
        echo "${cmd_output}"
    fi

    if [[ "${operation}" == "${OPERATION_READ}" ]]; then
        echo
    fi
}

operation="${OPERATION_READ}" # possible values = read, write, verify

if [[ "${DOTFILES_OS}" != "${DOTFILES_OS_MACOS}" ]]; then
    >&2 echo "This is not macOS."
    exit 1
fi

case "${1}" in
    "${OPERATION_WRITE}")
        operation="${OPERATION_WRITE}"
    ;;

    "${OPERATION_VERIFY}")
        operation="${OPERATION_VERIFY}"
    ;;

    *)
        operation="${OPERATION_READ}"
esac

settings=()

############### SYSTEM ###############

echo
echo "› System:"
echo "  › Show the ~/Library folder"
chflags nohidden ~/Library

echo "  › Show the /Volumes folder"
sudo chflags nohidden /Volumes

settings+=("System|Disable press-and-hold for keys in favor of key repeat|-g ApplePressAndHoldEnabled -bool|false")
settings+=("System|Use AirDrop over every interface|com.apple.NetworkBrowser BrowseAllInterfaces|1")
settings+=("System|Set a really fast key repeat|-g KeyRepeat -int|3") # it's supposed to be 45 ms
settings+=("System|Always show scrollbars|-g AppleShowScrollBars -string|Automatic") # possible values: `WhenScrolling`, `Automatic` and `Always`
settings+=("System|Disable Dashboard|com.apple.dashboard mcx-disabled -bool|true")
settings+=("System|Don't automatically rearrange Spaces based on most recent use|com.apple.dock mru-spaces -bool|false")
settings+=("System|Disable smart quotes and smart dashes as they're annoying when typing code #1|NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool|false")
settings+=("System|Disable smart quotes and smart dashes as they're annoying when typing code #2|NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool|false")
settings+=("System|Disable auto-correct|NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool|false")
settings+=("System|Avoid the creation of .DS_Store files on network volumes|com.apple.desktopservices DSDontWriteNetworkStores -bool|true")
settings+=("System|Show battery percent|com.apple.menuextra.battery ShowPercent -bool|true")
settings+=("System|Changing default screenshot folder|com.apple.screencapture location|${HOME}/Screenshots")

############### FINDER ###############

settings+=("Finder|Always open everything in Finder's list view|com.apple.Finder FXPreferredViewStyle|Nlsv")
settings+=("Finder|Set the Finder prefs for hiding volumes on the Desktop #1|com.apple.finder ShowExternalHardDrivesOnDesktop -bool|false")
settings+=("Finder|Set the Finder prefs for hiding volumes on the Desktop #2|com.apple.finder ShowRemovableMediaOnDesktop -bool|false")
settings+=("Finder|Expand save panel by default|NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool|true")
settings+=("Finder|Show status bar|com.apple.finder ShowStatusBar -bool|true")
settings+=("Finder|Show path bar|com.apple.finder ShowPathbar -bool|true")
settings+=("Finder|Save to disk by default, instead of iCloud|NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool|false")
settings+=("Finder|Display full POSIX path as Finder window title|com.apple.finder _FXShowPosixPathInTitle -bool|true")
settings+=("Finder|Disable the warning when changing a file extension|com.apple.finder FXEnableExtensionChangeWarning -bool|false")

############### PHOTOS ###############

settings+=("Photos|Disable it from starting everytime a device is plugged in|com.apple.ImageCapture disableHotPlug -bool|true")

############## BROWSERS ##############

settings+=("Browsers|Set up Safari for development #1|com.apple.Safari IncludeInternalDebugMenu -bool|true")
settings+=("Browsers|Set up Safari for development #2|com.apple.Safari IncludeDevelopMenu -bool|true")
settings+=("Browsers|Set up Safari for development #3|com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool|true")
settings+=("Browsers|Set up Safari for development #4|com.apple.Safari \"com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled\" -bool|true")
settings+=("Browsers|Set up Safari for development #5|NSGlobalDomain WebKitDeveloperExtras -bool|true")
settings+=("Browsers|Disable the annoying backswipe in Chrome|com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool|false")

################ DOCK ################

settings+=("Dock|Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate|com.apple.dock tilesize -int|50")
settings+=("Dock|Automatically hide and show the Dock|com.apple.dock autohide -bool|true")

################ MAIL ################

settings+=("Mail|Disable smart quotes as it's annoying for messages that contain code|com.apple.messageshelper.MessageController SOInputLineSettings -dict-add \"automaticQuoteSubstitutionEnabled\" -bool|false")

############ TIME MACHINE ############

settings+=("Time Machine|Prevent Time Machine from prompting to use new hard drives as backup volume|com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool|true")

######################################

last_setting_category=""

for setting_string in "${settings[@]}"; do
    setting_category="$(echo "${setting_string}" | cut -d '|' -f 1)"
    setting_desc="$(echo "${setting_string}" | cut -d '|' -f 2)"
    setting_name="$(echo "${setting_string}" | cut -d '|' -f 3)"
    setting_value="$(echo "${setting_string}" | cut -d '|' -f 4)"

    if [[ "${last_setting_category}" != "${setting_category}" ]]; then
        echo
        echo "› ${setting_category}:"
    fi

    cmd_defaults "${operation}" "${setting_desc}" "${setting_name}" "${setting_value}"

    last_setting_category="${setting_category}"
done
