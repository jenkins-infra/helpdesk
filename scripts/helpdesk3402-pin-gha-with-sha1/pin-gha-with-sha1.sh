#!/usr/bin/env bash

# For each YAML file found in the <repo>/.github/workflows folder, execute ratchet to pin GHA to their SHA-1 instead of their version number
find .github/workflows -maxdepth 1 -type f -name "*.y*" -exec /tmp/helpdesk3402/ratchet pin {} \;

# remove 'ratchet:org/repo@' from the comment to keep only the version
find .github/workflows -maxdepth 1 -type f -name "*.y*" -exec sed -i '' -r "s/# ratchet:[a-z0-9\/-]+@/# /g" {} \;

# don't use SHA-1 for official GitHub actions (in 'action' org)
find .github/workflows -maxdepth 1 -type f -name "*.y*" -exec sed -i '' -r "s/uses: \"?(actions\/[a-z0-9-]+@)[a-z0-9]+\"? # /uses: \1/g" {} \;

# don't use SHA-1 for official GitHub actions (in 'github' org)
find .github/workflows -maxdepth 1 -type f -name "*.y*" -exec sed -i '' -r "s/uses: \"?(github\/[a-z0-9-]+@)[a-z0-9]+\"? # /uses: \1/g" {} \;

# don't use SHA-1 for official Jenkins actions (in 'jenkins-infra' org)
find .github/workflows -maxdepth 1 -type f -name "*.y*" -exec sed -i '' -r "s/uses: \"?(jenkins-infra\/[a-z0-9-]+@)[a-z0-9]+\"? # /uses: \1/g" {} \;
