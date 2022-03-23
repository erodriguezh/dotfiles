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

  if [ ! -f ~/.android/repositories.cfg ]; then
    echo "Create repositories.cfg if it does not exists"
    mkdir -p ~/.android && touch ~/.android/repositories.cfg
  fi

  echo "Install Android SDK dependencies"
  /usr/local/share/android-sdk/tools/bin/sdkmanager "tools" "emulator" "platform-tools" "platforms;android-32" "build-tools;32.0.3" "extras;android;m2repository" "extras;google;m2repository" "sources;android-32" "system-images;android-32;google_apis;x86_64"
  echo "Accept all software licenses"
  /usr/local/share/android-sdk/tools/bin/sdkmanager --licenses
  echo "Create Pixel Emulator"
  /usr/local/share/android-sdk/tools/bin/avdmanager create avd -n Pixel -k 'system-images;android-32;google_apis;x86_64' -d 17
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
