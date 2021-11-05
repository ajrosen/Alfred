##################################################
# Initialize workflow environment

LPASS="${alfred_workflow_cache}/lpass"
BREW=""
PORT=""

# Try installing with a package manager
install () {
    osascript -e 'display dialog "Try installing with '${1}'?" with icon stop with title "Could not find LastPass CLI" buttons {"Cancel", "Install" } default button "Cancel"' > /dev/null

    if [ $? == 0 ]; then
	osascript -e 'display notification "Installing LastPass CLI"'
	osascript -e 'tell application "Terminal" to activate'
	osascript -e 'tell application "Terminal" to do script "'"$2"'"'
    fi
}

# Create local symlink
mklink () {
    for D in /usr/local/bin /opt/{homebrew,local}/bin /usr/local/Cellar/lastpass-cli/*/bin /opt/homebrew/Cellar/lastpass-cli/*/bin; do
	if [ -x "${D}"/lpass ]; then
	    mkdir -p "${alfred_workflow_cache}"
	    ln -sf "${D}/lpass" "${LPASS}"
	    break
	fi

	# Look for brew and port too
	[ -x "${D}"/brew ] && BREW="${D}"/brew
	[ -x "${D}"/port ] && PORT="${D}"/port
    done
}

# Check for symlink
if [ ! -x "${LPASS}" ]; then
    mklink

    # Check again
    if [ ! -x "${LPASS}" ]; then
	# Offer to install
	echo "LastPass CLI is not installed"
	[ "${BREW}" != "" ] && install "Homebrew" "${BREW} install lastpass-cli"
	[ "${PORT}" != "" ] && install "MacPorts" "sudo ${PORT} -N install lastpass-cli"
    fi
fi

export LPASS_DISABLE_PINENTRY=1
export PATH="${alfred_workflow_cache}":${PATH}
