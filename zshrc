echo 'Hello from .zshrc'
# Change #3 in another file on local. Shouldn't be able to push until I pull.
test-webui-merge-2 3rd change in another file

##########
# Exports
##########

# Make code the default editor.
export EDITOR='code';

# Set Environment Variables (and other Surprises)
# should HOMEBREW_CASK_OPTS be in zshenv or something?
export HOMEBREW_CASK_OPTS="--no-quarantine"
export NULLCMD=bat
export N_PREFIX="$HOME/.n"
export PREFIX="$N_PREFIX"
DOTFILES="$HOME/.dotfiles"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Adjust History Variables & Options
export HISTSIZE=5000
export SAVEHIST=4000

# TODO look into this
export TIME_STYLE=long-iso

# Bonus?
# Get some syntax highlighing for man pages using bat
# https://github.com/sharkdp/bat#man
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Java
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

# Android
export ANDROID_SDK_ROOT="~/Library/Android/sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export ANDROID_AVD_HOME="~/.android/avd/"

##########
# Aliases
##########

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Shortcuts
alias cddb="cd ~/Documents/Dropbox"
alias cddl="cd ~/Downloads"
alias cddt="cd ~/Desktop"
alias cddev="cd ~/Developer"

## Local configs
alias envconfig="code ~/dotfiles/zsh"
alias refreshconfig="source ~/.zshrc"

## Git
alias gl="git log --all --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(bold magenta)%d%C(reset)'"

## Npm
alias ni='npm install'
alias nis='npm install -S'
alias nid='npm install -D'
alias nu='npm uninstall'
alias nus='npm uninstall -S'
alias nud='npm uninstall -D'
alias nr='npm run'

# List all files colorized in long format
alias ls='exa -laFh --git'
alias exa='exa -laFh --git'

# Print path array separating each item on a new line
alias trail='<<<${(F)path}'
alias ftrail='<<<${(F)fpath}'

# Load History into shell (shareHistory alternative)
alias lh='fc -RI; echo "history loaded, now showing..."; history;'

# Get week number
alias week='date +%V'

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Merge PDF files, preserving hyperlinks
# Usage: `mergepdf input{1,2,3}.pdf`
alias mergepdf='gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=_merged.pdf'

# Copy public ssh key
alias copyssh="pbcopy < ~/.ssh/id_ed25519.pub"

## Matrix - Notes, Meetings
alias osu="code ~/Documents/notes/standup.md"

## Matrix - Shortcuts
alias cdmatrix="cd ~/Developer/matrix-frontend"
alias cdadmin="cd ~/Developer/matrix-admin"

## Matrix - Go native
alias gndebugbuild="./gradlew assembleDebug && cd app/build/outputs/apk/normal/debug && adb install *.apk"
alias gnreleasebuild="./gradlew assembleRelease && cd app/build/outputs/apk"

## Matrix - webserver
alias webserver-refresh="docker-compose down && docker-compose up -d matrix-frontend-webserver && docker-compose exec matrix-frontend-webserver sh"

## Matrix - Cash apps
alias oldplugincleaninstall="cd ~/Developer/matrix-frontend/cordova/svch && rm -rf platforms plugins && cordova plugin add git+ssh://git@ato-git-matrix.gtoffice.lan:cbend/nsdlfcvplugin && cordova plugin add git+ssh://git@ato-git-matrix.gtoffice.lan:cbend/nsdlf-matrix-ch-extension"
alias addchextensionplugin="cordova plugin add git+ssh://git@ato-git-matrix.gtoffice.lan:cbend/nsdlf-matrix-ch-extension"
alias addplugin="cordova plugin add git+ssh://git@ato-git-matrix.gtoffice.lan:cbend/nsdlfcvplugin"
alias addfatplugin="cordova plugin add git+ssh://git@ato-git-matrix.gtoffice.lan:cbend/nsdlfcvplugin_fat"
alias plugincleaninstall="cd ~/Developer/matrix-frontend/cordova/svch && cordova plugin rm com.greentube.nsdlf.matrix.ch && cordova plugin rm novo-ios-app-integration && rm -rf platforms plugins && cordova plugin add git+ssh://git@ato-git-matrix.gtoffice.lan:cbend/nsdlf-minibundles-ch-live-extension.git && cordova plugin add git+ssh://git@ato-git-matrix.gtoffice.lan:cbend/matrix-game-integration-plugin.git"
alias wholebuildprod="cd ~/Developer/matrix-frontend/cordova/svch && rm -rf platforms plugins && cd ~/Developer/matrix-frontend && npm run svch:mobile:prod:build && cd cordova/svch && npm run build:ios:simulator && open -a Xcode platforms/ios/"
alias wholebuildstag="cd ~/Developer/matrix-frontend/cordova/svch && rm -rf platforms plugins && cd ~/Developer/matrix-frontend && npm run svch:mobile:stag:build && cd cordova/svch && npm run build:ios:simulator && open -a Xcode platforms/ios/"

######################################
# Add Locations to the $path Variable
######################################

typeset -U path
path=(
  "$N_PREFIX/bin"
  "$ANDROID_SDK_ROOT/platform-tools"
  "$ANDROID_SDK_ROOT/tools"
  "$ANDROID_SDK_ROOT/bin"
  "$ANDROID_SDK_ROOT/emulator"
  $path
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
)

######################################
# Functions
######################################

# Create a new directory and enter it
function mkcd() {
  mkdir -p "$@" && cd "$_";
}

# Only create Brewfile in .dotfiles directory
function bbd() {
  local startingDirectory=$PWD;

  if [[ $startingDirectory != $DOTFILES ]]; then
    echo "Changing to $DOTFILES";
    cd $DOTFILES;
  fi

  echo "Dumping Brewfile";
  brew bundle dump --force --describe;

  if [[ $startingDirectory != $DOTFILES ]]; then
    echo "Returning to $startingDirectory";
    cd $startingDirectory;
  fi

}

## Matrix - Generate web build and build app. ma = matrix-apps
function ma() {
## Validations
    if [ "$1" != "adro" ] && 
       [ "$1" != "aduk" ] && 
       [ "$1" != "esto" ] && 
       [ "$1" != "feca" ] && 
       [ "$1" != "sg" ] && 
       [ "$1" != "svaes" ] && 
       [ "$1" != "svait" ] && 
       [ "$1" != "svch" ]
    then
        echo -e "Error: 1st parameter needs to be a value of adro, aduk, esto, feca, sg, svaes, svait, svch"
        return
    fi

    if [ "$2" != "stag" ] &&
       [ "$2" != "prod" ]
    then
        echo -e "Error: 2nd parameter needs to be a value of stag or prod"
        return
    fi

    if [ "$3" != "android" ] && 
       [ "$3" != "ios" ]
    then
        echo -e "Error: 3rd parameter needs to be a value of android or ios"
        return
    fi

    if [ "$4" != "simulator" ] && 
       [ "$4" != "device" ] &&
       [ "$4" != "" ]
    then
        echo -e "Error: 4th parameter is optional and needs to be a value of simulator or device"
        return
    fi

    if [ "$4" = "device" ] &&
       [ "$5" = "" ]
    then
        echo -e "Error: 5th parameter is mandatory and needs to be a value of appstore, adhoc or debug"
        return
    fi

    if [ "$5" != "appstore" ] && 
       [ "$5" != "adhoc" ] &&
       [ "$5" != "debug" ] &&
       [ "$5" != "" ]
    then
        echo -e "Error: 5th parameter is optional and needs to be a value of appstore, adhoc or debug"
        return
    fi

## Modifications

    cordovaBuildType=""
    openApp="open -a Xcode platforms/${3}/"

    if [ "$4" = "simulator" ] || 
       [ "$4" = "device" ] &&
    then
        cordovaBuildType=":${4}"
    fi

    if [ "$5" = "appstore" ] ||
       [ "$5" = "adhoc" ] ||
       [ "$5" = "debug" ]
    then
        cordovaBuildType="${cordovaBuildType}:${5}"
    fi

    # Old plugin 
    # cd ~/Developer/matrix-frontend && npm run ${1}:mobile:${2}:build && cd cordova/${1} && npm run cordova:build:${3}${cordovaBuildType} && ${openApp}
    
    # New plugin
    cd ~/Developer/matrix-frontend && npm run ${1}:mobile:${2}:build && cd cordova/${1} && npm run cordova:build:${3}:${2}${cordovaBuildType} && ${openApp}
}

## Matrix - Check nrgs version
function nrgsversion() {
    echo "ADRO:"
    curl https://staging.admiral.ro/nrgs/en/api/healthCheck-v1
    echo "\nADUK:"
    curl https://staging.admiralcasino.co.uk/nrgs/en/api/healthCheck-v1
    echo "\nFECA:"
    curl https://staging.feniksscasino.lv/nrgs/en/api/healthCheck-v1
    echo "\nSG:"
    curl https://staging.stargames.de/nrgs/en/api/healthCheck-v1
    echo "\nSVAES:"
    curl https://staging.starvegas.es/nrgs/en/api/healthCheck-v1
    echo "\nSVAIT:"
    curl https://staging.starvegas.it/nrgs/en/api/healthCheck-v1
    echo "\nSVCH:"
    curl https://staging.starvegas.ch/nrgs/en/api/healthCheck-v1
}

#########
# Extras
#########

# Adjust History Variables & Options
[ -z $HISTFILE ] && HISTFILE="$HOME/.zsh_history"
setopt histNoStore
setopt extendedHistory
setopt histIgnoreAllDups
unsetopt appendHistory # explicit and unnecessary
setopt incAppendHistoryTime

# Completion / Menu / Directory / etc. Options
# autoMenu & autoList are on by default
setopt autoCd
setopt globDots

# Case-insensitive globbing (used in pathname expansion)
setopt nocaseglob;

# Autocorrect typos in path names when using `cd`
ENABLE_CORRECTION="true"

# load antibody plugins
source ~/.zsh_plugins.sh

