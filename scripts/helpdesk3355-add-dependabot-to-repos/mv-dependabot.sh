#!/usr/bin/env bash

# dependabot.yml previously copied in the wrong repository repository via ./run-helpdesk3355.sh
SRC=".github/workflows/dependabot.yml" # Relative path
DEST=".github/dependabot.yml" # Relative path

mv $SRC $DEST
