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
alias envconfig="code ~/.dotfiles"
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
alias copyssh="pbcopy < ~/.ssh/id_rsa.pub"

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

