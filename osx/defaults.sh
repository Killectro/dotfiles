#!/usr/bin/env bash

# ~/.osx — http://mths.be/osx
# Watch for changes in files with either of
#  sudo fs_usage | grep plist
#  sudo opensnoop | grep plist
# Useful reference: http://www.hcs.harvard.edu/~jrus/Site/Cocoa%20Text%20System.html

killall System\ Preferences

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing 'sudo' time stamp until '.osx' has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


#
# General Settings
#

# Ask to keep changes on close
defaults write NSGlobalDomain NSCloseAlwaysConfirmsChanges -int 1

# Disables shutting down inactive applications
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Dark UI
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Disable 'smart' quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# https://mjtsai.com/blog/2020/10/05/big-surs-hidden-document-proxy-icon
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0


#
# Desktop & Screen Saver
#

# Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName


#
# Dock
#

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Don't show recents
defaults write com.apple.dock show-recents -bool false

# Disable the Launchpad gesture (pinch with thumb and three fingers)
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0


#
# Mission Control
#

# Don't show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Dock setup
if command -v dockutil; then
  dockutil --remove all

  dockutil --add "/Applications/Firefox.app"
  dockutil --add "/Applications/iTerm.app"
  dockutil --add "/Applications/Slack.app"
  dockutil --add "/Applications/Messages.app"
  dockutil --add "/Applications/Notes.app"

  dockutil --add "/Applications" --view list --display folder --sort name
  dockutil --add "$HOME/Downloads" --view grid --display stack --sort dateadded
else
  echo "dockutil not installed, re-run after installing"
fi

# Run hot corners script
if [[ -f ../bin/corners ]]; then
    ../bin/corners enable
else
    echo "Failed to setup hot corners, script missing"
fi


#
# Power Settings
#

# Disable auto-adjust brightness
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor.plist "Automatic Display Enabled" -bool false

# To stop the display from half dimming before full display 'sleep'
# http://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man1/pmset.1.html
sudo pmset -a halfdim 0

# Sleep options
sudo pmset -a displaysleep 5

# Wake for network access
sudo pmset -a womp 1

# Don't restart after power failure
sudo pmset -a autorestart 0

# Wake computer when laptop is opened
sudo pmset -a lidwake 1

# Don't wake computer when power source changes
sudo pmset -a acwake 0

# Don't dim brightness on any different source
sudo pmset -a lessbright 0


#
# Keyboard
#

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false


#
# Mouse/Trackpad
#

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1


#
# Date/Time
#

# 24 hour time
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true
defaults write NSGlobalDomain AppleICUTimeFormatStrings -dict \
  1 -string "H:mm" \
  2 -string "H:mm:ss" \
  3 -string "H:mm:ss z" \
  4 -string "H:mm:ss zzzz"


#
# Battery Percentage
#

defaults write com.apple.menuextra.battery ShowPercent -bool true


#
# Finder
#

# Show all icons on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show Status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Show Path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Use column view in all Finder windows by default
# Four-letter codes for the other view modes: 'icnv', 'clmv', 'Flwv', 'Nlsv'
defaults write com.apple.finder FXPreferredViewStyle -string clmv

# Allow text selection in QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string SCcf

# Finder: new window location set to $HOME. Same as Finder > Preferences > New Finder Windows show
# For other path use "PfLo" and "file:///foo/bar/"
defaults write com.apple.finder NewWindowTarget -string PfLo
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Default to local files instead of iCloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Empty Trash securely by default
# defaults write com.apple.finder EmptyTrashSecurely -bool true

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Don't use tabs in Finder
defaults write com.apple.finder AppleWindowTabbingMode -string "manual"

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 64" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist

# Remove all tags from contextual menu
/usr/libexec/PlistBuddy -c "Delete :FavoriteTagNames" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add :FavoriteTagNames array" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add :FavoriteTagNames:0 string" ~/Library/Preferences/com.apple.finder.plist


#
# Safari/WebKit
#

# Change the Safari search to find strings contained in other words
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Show developer tools
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Disable Webkit start page
defaults write org.webkit.nightly.WebKit StartPageDisabled -bool true

# Set Safari's home page to 'about:blank' for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening 'safe' files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Hide Safari’s sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

# Don't fill passwords
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -int 0

# Show full URL in Safari
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Show status bar
defaults write com.apple.Safari ShowStatusBar -bool true
defaults write com.apple.Safari ShowStatusBarInFullScreen -bool true

# Toolbar setup
/usr/libexec/PlistBuddy -c "Delete :NSToolbar\\ Configuration\\ BrowserToolbarIdentifier-v2:TB\\ Item\\ Identifiers" ~/Library/Preferences/com.apple.Safari.plist &>/dev/null
/usr/libexec/PlistBuddy -c "Add :NSToolbar\\ Configuration\\ BrowserToolbarIdentifier-v2:TB\\ Item\\ Identifiers array" ~/Library/Preferences/com.apple.Safari.plist
items=(BackForwardToolbarIdentifier NSToolbarFlexibleSpaceItem InputFieldsToolbarIdentifier NSToolbarFlexibleSpaceItem ShareToolbarIdentifier)

for i in "${!items[@]}"; do
  /usr/libexec/PlistBuddy -c "Add :NSToolbar\\ Configuration\\ BrowserToolbarIdentifier-v2:TB\\ Item\\ Identifiers:$i string ${items[$i]}" ~/Library/Preferences/com.apple.Safari.plist
done

#
# Messages
#


# Seems that Messages.app doesn't respect the system setting on Big Sur+ FB8920792
defaults write com.apple.messages.text SmartQuotes -bool false

# Add a shortcut for deleting messages
# NOTE: cmd+delete which was the previous shortcut doesn't work for some reason FB8920763
# defaults write "$HOME/Library/Preferences/com.apple.MobileSMS.plist" NSUserKeyEquivalents -dict 'Delete Conversation...' '@\U007F'
# NOTE: Something is wrong with how you reference the plist, sometimes the one in the Messages "container" is preferred, but isn't preferred by messages at runtime FB8920785
defaults write "$HOME/Library/Preferences/com.apple.MobileSMS.plist" NSUserKeyEquivalents -dict 'Delete Conversation...' '@d'

# Hide scrollbars in Messages.app
defaults write com.apple.iChat AppleShowScrollBars -string Automatic


#
# Other Applications
#

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false


#
# Other Interface changes
#

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true


#
# Other subtle changes
#

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string png

# Don't show iOS like thumbnail
defaults write com.apple.screencapture show-thumbnail -string -bool false

# Finally disable opening random Apple photo applications when plugging in devices
# https://twitter.com/stroughtonsmith/status/651854070496534528
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Enable automatic update & download
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Shows ethernet connected computers in airdrop
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
# Open an empty file directly
defaults write com.apple.TextEdit NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false
# Force files to open in new windows instead of new tabs
defaults write com.apple.TextEdit AppleWindowTabbingMode -string manual

# https://mjtsai.com/blog/2021/03/29/how-to-stop-mac-app-store-notifications
defaults write com.apple.appstored LastUpdateNotification -date "2029-12-12 12:00:00 +0000"


#
# Xcode
#

# Trim trailing whitespace
defaults write com.apple.dt.Xcode DVTTextEditorTrimTrailingWhitespace -bool true

# Trim whitespace only lines
defaults write com.apple.dt.Xcode DVTTextEditorTrimWhitespaceOnlyLines -bool true

# Show line numbers
defaults write com.apple.dt.Xcode DVTTextShowLineNumbers -bool true

# Hide the code folding ribbon
defaults write com.apple.dt.Xcode DVTTextShowFoldingSidebar -bool false

# Live issues
defaults write com.apple.dt.Xcode IDEEnableLiveIssues -bool true

# Enable internal debug menu
defaults write com.apple.dt.Xcode ShowDVTDebugMenu -bool true

# Source control local revision side
defaults write com.apple.dt.Xcode DVTComparisonOrientationDefaultsKey -int 0

# Show build times in toolbar
# http://cocoa.tumblr.com/post/131023038113/build-speed
defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool true

# Add more information to Xcode's build output about why specific commands are being run
# https://twitter.com/bdash/status/661742266487205888
# http://www.openradar.me/27516128
defaults write com.apple.dt.Xcode ExplainWhyBuildCommandsAreRun -bool true

# Write detailed build system info into derived data
# If you don't enable this but `mkdir /tmp/xcode_dependency_logs` the logs will
# be created there instead
defaults write com.apple.dt.Xcode EnableBuildSystemLogging -bool true

# Enable extra logging for XCBuild
defaults write com.apple.dt.XCBuild EnableDebugActivityLogs -bool true

# Set custom colorscheme
defaults write com.apple.dt.Xcode XCFontAndColorCurrentTheme -string "Solarized Dark.xccolortheme"
defaults write com.apple.dt.Xcode XCFontAndColorCurrentDarkTheme -string "Solarized Dark.xccolortheme"

# Show indexing progress
# https://twitter.com/dmartincy/status/1034930612543676418
defaults write com.apple.dt.Xcode IDEIndexerActivityShowNumericProgress -bool true

# Make command click jump to definition instead of showing the menu
defaults write com.apple.dt.Xcode IDECommandClickNavigates -bool true

# https://gist.github.com/tkersey/6b6c1d91415c785a10560ae564288a65
defaults write com.apple.dt.Xcode ShowDVTDebugMenu -bool true

# Hide the Xcode 11 minimap
defaults write com.apple.dt.Xcode DVTTextShowMinimap -bool false

# Enable better core utilization from Swift build system
# https://developer.apple.com/documentation/xcode-release-notes/xcode-13_2-release-notes
defaults write com.apple.dt.XCBuild EnableSwiftBuildSystemIntegration 1

#
# Third Party
#

# Firefox
defaults write org.mozilla.firefox AppleShowScrollBars -string "Automatic"

echo "DOAOAone. Note that some of these changes require a logout/restart to take effect."
# vim:tw=0

