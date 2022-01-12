#!/usr/bin/env bash
# This is a script for bootstrapping macOS setup

set -euo pipefail

if [[ ! -e ./manage.sh ]]; then
  echo "This script must be run from the root of the dotfiles repo"
  exit 1
fi

chmod u+x ./manage.sh

./manage.sh install

# Set correct netrc permissions
touch "$HOME/.netrc"
chmod 0600 "$HOME/.netrc"

echo "Copying iTerm plist"
cp iterm/com.googlecode.iterm2.plist  ~/Library/Preferences/

echo "Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

if ! command -v brew &> /dev/null; then
  echo "Homebrew install failed"
  exit 1
fi

# Install some default software
brew bundle --file="./osx/Brewfile"
brew bundle --file="./osx/Brewfile.cask"

# Install non-system Ruby version
frum install 2.7.5

echo "Installing bundler"
gem install bundler

if [[ ! -e "$HOME/.zshrc" ]]; then
  echo "Looks like the manage script failed, try and run it manually"
  exit 1
fi

bundle config set --local system 'true'
bundle install --gemfile="./osx/Gemfile"

# Set many default settings
./osx/defaults.sh
