echo "\n~~~ Setup Prechecks ~~~\n"

# Detect platform.
if [ "$(uname -s)" != "Darwin" ]; then
  echo "These dotfiles only targets macOS."
  exit 1
fi

# Check current shell interpreter.
ps -p $$ | grep "zsh"
if [ $? != 0 ]; then
  echo "These dotfiles were tested with Zsh shell only."
  exit 1
fi

# Check if SIP is going to let us mess with some part of the system.
SIP_DISABLED=$(csrutil status | grep --quiet "enabled"; echo $?)
if [[ ${SIP_DISABLED} -ne 0 ]]; then
  echo "System Integrity Protection (SIP) is disabled."
else
  echo "System Integrity Protection (SIP) is enabled."
fi
