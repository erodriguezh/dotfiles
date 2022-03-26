#!/usr/bin/env zsh

echo "\n~~~ Starting Nativescript Setup ~~~\n"

# Custom check if exists for ruby gems
function gem_is_installed() {
  if [[ -z "${1:-}" ]]
  then
    error "No gem name specified.\n" && exit 1
  fi
  [[ "$(gem list "^${1:-}$" -i)" == "true" ]]
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
  python -m pip install --upgrade pip

  if [ ! -f ~/.android/repositories.cfg ]; then
    echo "Create repositories.cfg if it does not exists"
    mkdir -p ~/.android && touch ~/.android/repositories.cfg
  fi

  echo "Add keyboard forwarding for Android emulator"
  for file in ~/.android/avd/*avd; do 
    if cat $file/config.ini | grep "hw.keyboard=yes" > /dev/null; then 
      echo "✔ hw.keyboard is already added to $(basename $file)"
    else 
      echo "hw.keyboard=yes" >> $file/config.ini
      echo "✔ hw.keyboard=yes is added to $(basename $file)"
    fi
  done
fi

# Show what's installed?
echo "Nativescript current setup state:"
ns doctor
