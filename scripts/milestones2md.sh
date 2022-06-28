#!/usr/bin/env bash

# Requirements:
# - gh cli: https://github.com/cli/cli
# - jq: https://stedolan.github.io/jq/

# Display a list of issues from a milestone
# Take as parameters the milestone id, its name, the state of the issues ("open" or "closed")
function displayMilestoneAsMarkdown() {
  milestone_id=$1
  milestone_name=$2
  state=$3
  if [[ $state = "open" ]] ; then sort_desc='sort_by(.url) | reverse | '; else sort_desc=''; fi
  
  readarray -t my_array < <(gh issue list --repo jenkins-infra/helpdesk -m=$milestone_id --state="${state}" --json=title,url | jq -c "${sort_desc}.[]")

  echo "## ${state} issues in [${milestone_name} milestone](https://github.com/jenkins-infra/helpdesk/milestones/${milestone_id}):"
  # iterate through the Bash array
  for item in "${my_array[@]}"; do
    title=$(jq -r '.title' <<< "${item}")
    url=$(jq -r '.url' <<< "${item}")
    echo "  * [${title}](${url})"
  done
  echo
}

# List open milestones
echo "List of the open milestones:"
curl -s https://api.github.com/repos/jenkins-infra/helpdesk/milestones | jq -c '.[] | {title, number}'

# 'next' milestone id, shouldn't need to be changed
GH_NEXT_MILESTONE_ID=10

# Current milestone id (https://github.com/jenkins-infra/helpdesk/milestones)
echo 'Which of these milestones above is the current one? Enter its number below:'
read GH_CURRENT_MILESTONE_ID

displayMilestoneAsMarkdown ${GH_CURRENT_MILESTONE_ID} current closed
displayMilestoneAsMarkdown ${GH_CURRENT_MILESTONE_ID} current open
echo '--------'
displayMilestoneAsMarkdown ${GH_NEXT_MILESTONE_ID} next closed
displayMilestoneAsMarkdown ${GH_NEXT_MILESTONE_ID} next open
