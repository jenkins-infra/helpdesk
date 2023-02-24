#!/usr/bin/env bash

# This script ensures the pinning of every GitHub Action with a SHA-1 (immutable) instead of a version number, for security purpose.
# It uses https://github.com/sethvargo/ratchet (version 0.4.0 included here)
# See https://github.com/jenkins-infra/helpdesk/issues/3402
#
# Usage:
#
# Requirements:
# - https://github.com/lindell/multi-gitter
# - A GitHub Personal Access Token in GITHUB_TOKEN env var, and also in ACTIONS_TOKEN (to avoid rate limiting with ratchet)
#
## Repositories in the jenkins-infra GitHub organisation using at least a GitHub Action (ie having a "worklows" folder)
## found with `find . -type d -name "workflows" | sort -u` in a folder containing all jenkins-infra repositories
## Note: manually removed the archived repositories from the results

if ! [ -x "$(command -v multi-gitter)" ]; then
  echo 'Error: multi-gitter is not installed.' >&2
  exit 1
fi

if ! [ -n ${GITHUB_TOKEN-} ]; then
  echo 'Error: the GITHUB_TOKEN env var is not set.' >&2
  exit 1
fi

if ! [ -n ${ACTIONS_TOKEN-} ]; then
  echo 'Error: the ACTIONS_TOKEN env var is not set.' >&2
  exit 1
fi

# Get ratchet binary from https://github.com/sethvargo/ratchet/releases

# Copy the ratchet binary to a temporary folder in order to ensure an absolute path to it for use in the script called by multi-gitter
mkdir -p /tmp/helpdesk3402
cp ./ratchet /tmp/helpdesk3402/ratchet
# ensure it's executable
chmod +x /tmp/helpdesk3402/ratchet

multi-gitter run ./pin-gha-with-sha1.sh --conflict-strategy replace --reviewers dduportal --reviewers smerle33 --branch helpdesk3402-pin-gha-with-sha1 --log-level=debug -m "chore: pin GitHub actions with their SHA-1 instead of their version number" --pr-body "Ref: https://github.com/jenkins-infra/helpdesk/issues/3402" \
--repo jenkins-infra/account-app \
--repo jenkins-infra/captain-hook \
--repo jenkins-infra/docker-404 \
--repo jenkins-infra/docker-builder \
--repo jenkins-infra/docker-confluence-data \
--repo jenkins-infra/docker-crond \
--repo jenkins-infra/docker-hashicorp-tools \
--repo jenkins-infra/docker-helmfile \
--repo jenkins-infra/docker-jenkins-lts \
--repo jenkins-infra/docker-jenkins-weekly \
--repo jenkins-infra/docker-mirrorbits \
--repo jenkins-infra/docker-openvpn \
--repo jenkins-infra/docker-packaging \
--repo jenkins-infra/docker-plugin-site-issues \
--repo jenkins-infra/docker-rsyncd \
--repo jenkins-infra/docker-terraform \
--repo jenkins-infra/gatsby-plugin-jenkins-layout \
--repo jenkins-infra/github-reusable-workflows \
--repo jenkins-infra/helm-charts \
--repo jenkins-infra/helpdesk \
--repo jenkins-infra/ideas \
--repo jenkins-infra/incrementals-publisher \
--repo jenkins-infra/ircbot \
--repo jenkins-infra/jenkins-infra \
--repo jenkins-infra/jenkins-io-components \
--repo jenkins-infra/jenkins-security-scan \
--repo jenkins-infra/jenkins-version \
--repo jenkins-infra/kubernetes-management \
--repo jenkins-infra/packer-images \
--repo jenkins-infra/pipeline-library \
--repo jenkins-infra/pipeline-metadata-utils \
--repo jenkins-infra/plugin-health-scoring \
--repo jenkins-infra/plugin-site \
--repo jenkins-infra/rating \
--repo jenkins-infra/release \
--repo jenkins-infra/repository-permissions-updater \
--repo jenkins-infra/status

rm -rf /tmp/helpdesk3402
