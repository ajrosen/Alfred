SCRIPTS += com.apple.Safari
SCRIPTS += com.google.Chrome
SCRIPTS += com.microsoft.edgemac
SCRIPTS += com.operasoftware.Opera
SCRIPTS += org.mozilla.firefox

REPO = ~/Sync/GitHub/Alfred/LastPass\ Accelerator

.SUFFIXES: .applescript

.applescript:
	osacompile -o $@ $?

diff:
	rsync -avn --del --delete-excluded --exclude=info.plist . ${REPO}

scripts: ${SCRIPTS}

checkin: scripts
	rsync -av --del --delete-excluded --exclude=info.plist . ${REPO}

commit: checkin

push: commit

all: scripts push
