#!/usr/bin/env bash

# Usage:
#
# Requirements:
# - https://github.com/lindell/multi-gitter
# - A GitHub Personal Access Token in GITHUB_TOKEN env var

# # Repositories without dependabot, main branch
# jenkins-infra/account-app
# jenkins-infra/docker-404
# jenkins-infra/docker-builder
# jenkins-infra/docker-confluence-data
# jenkins-infra/docker-crond
# jenkins-infra/docker-hashicorp-tools
# jenkins-infra/docker-helmfile
# jenkins-infra/docker-mirrorbits
# jenkins-infra/docker-packaging
# jenkins-infra/docker-plugin-site-issues
# jenkins-infra/docker-rsyncd
# jenkins-infra/gatsby-plugin-jenkins-layout
# jenkins-infra/jenkins-io-components
# jenkins-infra/kubernetes-management
# jenkins-infra/packer-images

# # Repositories without dependabot, master branch
# jenkins-infra/plugin-site
# jenkins-infra/incrementals-publisher
# jenkins-infra/rating
# jenkins-infra/release

if ! [ -x "$(command -v multi-gitter)" ]; then
  echo 'Error: multi-gitter is not installed.' >&2
  exit 1
fi

multi-gitter run ./mv-dependabot.sh --reviewers dduportal --reviewers smerle33 --branch helpdesk3355-add-dependabot --log-level=debug -m "fixup: move dependabot to the correct folder" --pr-body "Ref: https://github.com/jenkins-infra/helpdesk/issues/3355" \
--repo jenkins-infra/account-app \
--repo jenkins-infra/docker-404 \
--repo jenkins-infra/docker-builder \
--repo jenkins-infra/docker-confluence-data \
--repo jenkins-infra/docker-crond \
--repo jenkins-infra/docker-hashicorp-tools \
--repo jenkins-infra/docker-helmfile \
--repo jenkins-infra/docker-mirrorbits \
--repo jenkins-infra/docker-packaging \
--repo jenkins-infra/docker-plugin-site-issues \
--repo jenkins-infra/docker-rsyncd \
--repo jenkins-infra/gatsby-plugin-jenkins-layout \
--repo jenkins-infra/jenkins-io-components \
--repo jenkins-infra/kubernetes-management \
--repo jenkins-infra/packer-images \
--repo jenkins-infra/plugin-site \
--repo jenkins-infra/incrementals-publisher \
--repo jenkins-infra/rating \
--repo jenkins-infra/release
