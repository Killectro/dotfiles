#!/bin/bash
#
# If you change these files in the Xcode UI, it will remove the symlinks and
# duplicate them. In that case you should copy them back to this repo, and
# re-run this script.
#
# http://www.openradar.me/42206958
#

set -euo pipefail

readonly colors="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
rm -f "$colors/Solarized Dark.xccolortheme"
mkdir -p "$colors"
ln -s "$DOTFILES/xcode/Solarized Dark.xccolortheme" "$colors"

