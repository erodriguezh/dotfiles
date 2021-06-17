#!/usr/bin/env zsh

echo "\n~~~ Starting Nativescript Setup ~~~\n"

# Custom check if exists for ruby gems
function gem_is_installed() {
  if [[ -z "${1:-}" ]]
  then
    error "No gem name specified.\n" && exit 1
  fi
  [[ "$(gem query -i -n "^t$")" == "true" ]]
}

if exists ns; then
  echo "Nativescript ($(ns --version)) is already setup"
else
  echo "Installing Nativescript dependencies"
  if gem_is_installed "xcodeproj"; then
    echo "gem xcodeproj is already installed"
  else
    sudo gem install xcodeproj
  fi
  if gem_is_installed "cocoapods"; then
    echo "gem cocoapods is already installed"
  else
    sudo gem install cocoapods
  fi
  echo "Setup Cocoapods"
  pod setup
  echo "Install python six package"
  /usr/local/bin/pip3 install six
  echo "Install Android SDK dependencies"
  /usr/local/share/android-sdk/tools/bin/sdkmanager "tools" "emulator" "platform-tools" "platforms;android-29" "build-tools;29.0.3" "extras;android;m2repository" "extras;google;m2repository"
fi

# Show what's installed?
echo "Nativescript current setup state:"
ns doctor


