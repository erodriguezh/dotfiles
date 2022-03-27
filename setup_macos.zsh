#!/usr/bin/env zsh

echo "\n~~~ Starting macOS Setup ~~~\n"

osascript -e 'tell application "System Preferences" to quit'

###########################
# System Preferences
###########################

PRIMARY_CLOUDFLARE_DNS_ADDRESS="1.1.1.1"
SECONDARY_CLOUDFLARE_DNS_ADDRESS="1.0.0.1"
FIRST_REDUNDANT_CLOUDFLARE_DNS_ADDRESS="2606:4700:4700::1111"
SECOND_REDUNDANT_CLOUDFLARE_DNS_ADDRESS="2606:4700:4700::1001"

# Update DNS servers to Cloudflare's servers https://one.one.one.one/dns/
networksetup -setdnsservers Wi-Fi $PRIMARY_CLOUDFLARE_DNS_ADDRESS $SECONDARY_CLOUDFLARE_DNS_ADDRESS $FIRST_REDUNDANT_CLOUDFLARE_DNS_ADDRESS $SECOND_REDUNDANT_CLOUDFLARE_DNS_ADDRESS

# Disable the sound effects on boot
echo "Enter password to disable start up chime"
sudo nvram SystemAudioVolume=" "

# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Disable Resume system-wide - get back to the exact state of the app even when system reboots
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Show battery percentage in menu bar
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.battery" -bool true
defaults write com.apple.menuextra.battery '{ ShowPercent = YES; }'

###########################
# Energy Preferences
###########################

# Sleep the display after 15 minutes
echo "Enter password to setup display sleep on both power adapter and battery"
sudo pmset -a displaysleep 15

# Disable machine sleep while charging
echo "Enter password to setup sleep while charging"
sudo pmset -c sleep 0

# Set machine sleep to 5 minutes on battery
echo "Enter password to setup display sleep on battery"
sudo pmset -b sleep 5

#########  
# Finder
#########
# Save screenshots to Screenshots folder
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"

# Set User home as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string 'PfLo'
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"

# disable status bar
defaults write com.apple.finder ShowStatusBar -bool false

# disable path bar
defaults write com.apple.finder ShowPathbar -bool false

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Use list view in all Finder windows by default
# Four-letter codes for view modes: icnv, clmv, Flwv, Nlsv
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

#######
# Dock
#######
# Disable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilite-stack -bool false

# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 36

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Set dock on the left side of the display
defaults write com.apple.dock orientation -string "right"

# Add a spacer to the right side of the Dock (where the Trash is)
defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'



#######
# Finish setup
#######
killall Finder
killall Dock
echo "Done with macOS setup. A logout or restart might be necessary."

