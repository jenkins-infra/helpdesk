#!/usr/bin/env bash

# Usage:
#
# Requirements:
# - https://github.com/lindell/multi-gitter
# - A GitHub Personal Access Token in GITHUB_TOKEN env var

# dependabot.yml previously copied in this repository via ./run-helpdesk3355.sh
SRC="/tmp/helpdesk3355/dependabot.yml"
DEST=".github/workflows/dependabot.yml"

# Don't replace the file if it already exists in the repo
if [ -f "$FILE" ]; then
    exit 1
fi

mkdir -p .github/workflows
cp $SRC $DEST
