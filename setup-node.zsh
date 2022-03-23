#!/usr/bin/env zsh

echo "\n~~~ Starting Node Setup ~~~\n"

# Node versions are managed with n, which is already in Brewfile.
# See zshrc for N_PREFIX and N_PREFIX/bin addition to $path.

if exists node; then
  echo "Node ($(node --version)) & NPM ($(npm --version)) already installed"
else
  echo "Installing Node and NPM..."
  n 14.19.1
fi


# Install NPM Packages
npm install --global firebase-tools
npm install --global @angular/cli
npm install --global nativescript
npm install --global npkill
npm install --global yarn

# Show what's installed?
echo "Global NPM Packages Installed:"
npm list --global --depth=0


