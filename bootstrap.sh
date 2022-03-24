#!/usr/bin/env bash

main() {
    ask_for_sudo
    # install_xcode_command_line_tools # to get "git", needed for clone_dotfiles_repo
    # clone_dotfiles_repo
    # install_homebrew
    # install_packages_with_brewfile
    # change_shell_to_zsh
    # setup_antibody
    # install_node
    # install_npm_packages
    install_mobile_dependencies
    # setup_vscode
    # setup_symlinks
    # setup_macOS_defaults
    # update_login_items
}

DOTFILES_REPO=~/dotfiles

function ask_for_sudo() {
    info "Prompting for sudo password"
    if sudo --validate; then
        # Keep-alive
        while true; do sudo --non-interactive true; \
            sleep 10; kill -0 "$$" || exit; done 2>/dev/null &
        success "Sudo password updated"
    else
        error "Sudo password update failed"
        exit 1
    fi
}

function install_xcode_command_line_tools() {
    info "Installing Xcode command line tools"

    if softwareupdate --history | grep --silent "Command Line Tools"; then
        success "Xcode command line tools already exists"
    else
        xcode-select --install
        while true; do
            if softwareupdate --history | grep --silent "Command Line Tools"; then
                success "Xcode command line tools installation succeeded"
                break
            else
                substep "Xcode command line tools still installing..."
                sleep 20
            fi
        done
    fi
}

function install_homebrew() {
    info "Installing Homebrew"
    if hash brew 2>/dev/null; then
        success "Homebrew already exists"
    else
        url=https://raw.githubusercontent.com/Homebrew/install/master/install
        if yes | /usr/bin/ruby -e "$(curl -fsSL ${url})"; then
            success "Homebrew installation succeeded"
        else
            error "Homebrew installation failed"
            exit 1
        fi
    fi
}

function install_packages_with_brewfile() {
    info "Installing Brewfile packages"

    TAP=${DOTFILES_REPO}/brew/Brewfile_tap
    BREW=${DOTFILES_REPO}/brew/Brewfile_brew
    CASK=${DOTFILES_REPO}/brew/Brewfile_cask
    MAS=${DOTFILES_REPO}/brew/Brewfile_mas

    if hash parallel 2>/dev/null; then
        substep "parallel already exists"
    else
        if brew install parallel &> /dev/null; then
            printf 'will cite' | parallel --citation &> /dev/null
            substep "parallel installation succeeded"
        else
            error "parallel installation failed"
            exit 1
        fi
    fi

    if (echo $TAP; echo $BREW; echo $CASK; echo $MAS) | parallel --verbose --linebuffer -j 4 brew bundle check --file={} &> /dev/null; then
        success "Brewfile packages are already installed"
    else
        if brew bundle --file="$TAP"; then
            substep "Brewfile_tap installation succeeded"

            export HOMEBREW_CASK_OPTS="--no-quarantine"
            if (echo $BREW; echo $CASK; echo $MAS) | parallel --verbose --linebuffer -j 3 brew bundle --file={}; then
                success "Brewfile packages installation succeeded"
            else
                error "Brewfile packages installation failed"
                exit 1
            fi
        else
            error "Brewfile_tap installation failed"
            exit 1
        fi
    fi
}

function change_shell_to_zsh() {
    info "zsh shell setup"
    if grep --quiet zsh <<< "$SHELL"; then
        success "zsh shell already exists"
    else
        user=$(whoami)
        substep "Adding zsh executable to /etc/shells"
        if grep --fixed-strings --line-regexp --quiet \
            "/usr/local/bin/zsh" /etc/shells; then
            substep "zsh executable already exists in /etc/shells"
        else
            if echo /usr/local/bin/zsh | sudo tee -a /etc/shells > /dev/null;
            then
                substep "zsh executable successfully added to /etc/shells"
            else
                error "Failed to add zsh executable to /etc/shells"
                exit 1
            fi
        fi
        substep "Switching shell to zsh for \"${user}\""
        if sudo chsh -s /usr/local/bin/zsh "$user"; then
            success "zsh shell successfully set for \"${user}\""
        else
            error "Please try setting zsh shell again"
        fi
        substep "Setting proper permissions for zsh"
        if sudo chmod -R 755 /usr/local/share/zsh && \
           sudo chown -R "$user":staff /usr/local/share/zsh; then
            success "zsh shell successfully set for \"${user}\""
        else
            error "Failed to set proper permissions to zsh"
        fi
    fi
}

function setup_antibody() {
    info "Setting up antibody."
    antibody bundle <"$DOTFILES_REPO/antibody/bundles.txt" > ~/.zsh_plugins.sh
    antibody update
}

function install_node() {
    info "Installing node"
    if test ! $(which nvm); then
        substep "Installing nvm"

        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | zsh
        source ~/.zshrc
    else
        success "NVM is already installed. Skipping.."
    fi
    
    if which node > /dev/null; then
        success "node is already installed, skipping..."
    else
        substep "Install latest Node LTS version"
        nvm install --lts
    fi
    success "node installation done"
}

function install_npm_packages() {
    npm_packages=(@angular/cli firebase-tools nativescript)
    info "Installing npm packages \"${npm_packages[*]}\""

    npm_list_outcome=$(npm global list)
    for package_to_install in "${npm_packages[@]}"
    do
        if echo "$npm_list_outcome" | \
            grep --ignore-case "$package_to_install" &> /dev/null; then
            substep "\"${package_to_install}\" already exists"
        else
            if npm install -g "$package_to_install"; then
                substep "Package \"${package_to_install}\" installation succeeded"
            else
                error "Package \"${package_to_install}\" installation failed"
                exit 1
            fi
        fi
    done

    success "npm packages successfully installed"
}

function clone_dotfiles_repo() {
    info "Cloning dotfiles repository into ${DOTFILES_REPO}"
    if test -e $DOTFILES_REPO; then
        substep "${DOTFILES_REPO} already exists"
        pull_latest $DOTFILES_REPO
        success "Pull successful in ${DOTFILES_REPO} repository"
    else
        url=https://github.com/erodriguezh/dotfiles.git
        if git clone "$url" $DOTFILES_REPO && \
           git -C $DOTFILES_REPO remote set-url origin git@github.com:erodriguezh/dotfiles.git; then
            success "Dotfiles repository cloned into ${DOTFILES_REPO}"
        else
            error "Dotfiles repository cloning failed"
            exit 1
        fi
    fi
}

function pull_latest() {
    substep "Pulling latest changes in ${1} repository"
    if git -C $1 pull origin master &> /dev/null; then
        return
    else
        error "Please pull latest changes in ${1} repository manually"
    fi
}

function install_mobile_dependencies() {
    info "Installing Mobile dependencies"
    if command -v tns >/dev/null; then
        substep "Adding Nativescript dependencies"
        if gem_is_installed "xcodeproj"; then
            success "gem xcodeproj is already installed"
        else
            sudo gem install xcodeproj
        fi
        if gem_is_installed "cocoapods"; then
            success "gem cocoapods is already installed"
        else
            sudo gem install cocoapods
        fi
        substep "Setup Cocoapods"
        pod setup
        substep "Install python six package"
        /usr/local/bin/pip3 install six
        substep "Install Android SDK dependencies"
        /usr/local/share/android-sdk/tools/bin/sdkmanager "tools" "emulator" "platform-tools" "platforms;android-29" "build-tools;29.0.3" "extras;android;m2repository" "extras;google;m2repository"
    else
        success "Nativescript is already installed"
    fi
    success "Mobile dependencies successfully installed"
}

function setup_vscode() {
    info "Setting up vscode"
    if command -v code >/dev/null; then
        if [ "$(uname -s)" = "Darwin" ]; then
            VSCODE_HOME="$HOME/Library/Application Support/Code"
        else
            VSCODE_HOME="$HOME/.config/Code"
        fi
        mkdir -p "$VSCODE_HOME/User"

        ln -sf "$DOTFILES_REPO/vscode/settings.json" "$VSCODE_HOME/User/settings.json"

        while read -r module; do
            code --install-extension "$module" || true
        done <"$DOTFILES_REPO/vscode/extensions.txt"
        success "vscode successfully setup"
    else
        error "Setting up vscode failed"
        exit 1
    fi
}

function setup_symlinks() {
    APPLICATION_SUPPORT=~/Library/Application\ Support

    info "Setting up symlinks"
    symlink "git" ${DOTFILES_REPO}/git/gitconfig.symlink ~/.gitconfig
    symlink "karabiner" ${DOTFILES_REPO}/karabiner ~/.config/karabiner # We are here

    # Disable shell login message
    symlink "hushlogin" /dev/null ~/.hushlogin

    symlink "user:exports" ${DOTFILES_REPO}/zsh/exports.symlink ~/.config/zsh/exports
    symlink "user:aliases" ${DOTFILES_REPO}/zsh/aliases.symlink ~/.config/zsh/aliases
    symlink "user:functions" ${DOTFILES_REPO}/zsh/functions.symlink ~/.config/zsh/functions
    symlink "user:user_profile" ${DOTFILES_REPO}/zsh/user_profile.symlink ~/.user_profile
    symlink "user:zshrc" ${DOTFILES_REPO}/zsh/zshrc.symlink ~/.zshrc

    success "Symlinks successfully setup"
}

function symlink() {
    application=$1
    point_to=$2
    destination=$3
    destination_dir=$(dirname "$destination")

    if test ! -e "$destination_dir"; then
        substep "Creating ${destination_dir}"
        mkdir -p "$destination_dir"
    fi
    if rm -rf "$destination" && ln -s "$point_to" "$destination"; then
        substep "Symlinking for \"${application}\" done"
    else
        error "Symlinking for \"${application}\" failed"
        exit 1
    fi
}

function setup_macOS_defaults() {
    info "Updating macOS defaults"

    current_dir=$(pwd)
    cd ${DOTFILES_REPO}/macos
    if zsh defaults.sh; then
        cd $current_dir
        success "macOS defaults updated successfully"
    else
        cd $current_dir
        error "macOS defaults update failed"
        exit 1
    fi
}

function update_login_items() {
    info "Updating login items"

    if osascript ${DOTFILES_REPO}/macos/login_items.applescript &> /dev/null; then
        success "Login items updated successfully "
    else
        error "Login items update failed"
        exit 1
    fi
}

function coloredEcho() {
    local exp="$1";
    local color="$2";
    local arrow="$3";
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white|*) color=7 ;; # white or invalid color
       esac
    fi
    tput bold;
    tput setaf "$color";
    echo "$arrow $exp";
    tput sgr0;
}

function info() {
    coloredEcho "$1" blue "========>"
}

function substep() {
    coloredEcho "$1" magenta "===="
}

function success() {
    coloredEcho "$1" green "========>"
}

function error() {
    coloredEcho "$1" red "========>"
}

function gem_is_installed() {
  if [[ -z "${1:-}" ]]
  then
    error "No gem name specified.\n" && exit 1
  fi
  [[ "$(gem query -i -n "^t$")" == "true" ]]
}

if [ "${1}" != "--source-only" ]; then
    main "${@}"
fi
