#!/usr/bin/env bash

# dependabot.yml previously copied in this repository via ./run-helpdesk3355.sh
SRC="/tmp/helpdesk3355/dependabot.yml" # Absolute path on the machine where we're executing the multi-gitter script
DEST=".github/dependabot.yml" # Relative path from the repository currently processed by multi-gitter

# Don't replace the file if it already exists in the repo
if [ -f "$FILE" ]; then
    exit 1
fi

mkdir -p .github
cp $SRC $DEST
