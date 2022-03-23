echo 'Hello from .zshenv'

# Write handy functions

function exists() {
  # Similar to "which" which would work just as well.
  # https://stackoverflow.com/a/677212/1341838
  # command -v $1 >/dev/null 2>&1
  # or more explicitly written...
  command -v $1 1>/dev/null 2>/dev/null

  # which -s $1
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
	if [ $# -eq 0 ]; then
		open .;
	else
		open "$@";
	fi;
}