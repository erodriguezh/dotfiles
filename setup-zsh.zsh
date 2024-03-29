#!/usr/bin/env zsh

echo "\n~~~ Starting ZSH Setup ~~~\n"

# Installation unnecessary; it's already in Brewfile.


# https://stackoverflow.com/a/4749368/1341838
if grep -Fxq '/usr/local/bin/zsh' '/etc/shells'; then
  echo '/usr/local/bin/zsh already exists in /etc/shells'
else
  # echo "Enter password to add /usr/local/bin/zsh to /etc/shells"
  # echo "Enter sudo password to edit /etc/shells"
  echo "sudo password required to edit /etc/shells"
  echo '/usr/local/bin/zsh' | sudo tee -a '/etc/shells' >/dev/null
fi


if [ "$SHELL" = '/usr/local/bin/zsh' ]; then
  echo '$SHELL is already /usr/local/bin/zsh'
else
  # echo "Enter password to change login shell to /usr/local/bin/zsh"
  # echo "Enter user password to change login shell"
  echo "user password required to change login shell"
  chsh -s /usr/local/bin/zsh
fi


# if command ls -la /private/var/select/sh | grep -q /bin/zsh; then
if sh --version | grep -q zsh; then
  echo '/private/var/select/sh already linked to /bin/zsh'
else
  # Looked cute, might delete later, idk
  sudo ln -sfv /bin/zsh /private/var/select/sh
  
  # I'd like for this to work instead.
  # sudo ln -sfv /usr/local/bin/zsh /private/var/select/sh
fi

# Setup antibody plugins
antibody bundle <"$HOME/dotfiles/antibody_plugins.txt" > ~/.zsh_plugins.sh
antibody update




# Look into later:
# /usr/local/Cellar/zsh/5.8/share/zsh/functions

# These are aliased to 5.8. What where they before
# I updated with Homebrew?
# /usr/local/share/zsh/functions