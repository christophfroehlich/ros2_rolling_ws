#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <owner/repo> <pr-number>"
  exit 1
fi

REPO=$1
PR_NUMBER=$2

BRANCH=$(gh pr view "$PR_NUMBER" --repo "$REPO" --json headRefName -q .headRefName)

echo "Cancelling all runs for PR #$PR_NUMBER (branch: $BRANCH in $REPO)..."

gh run list --limit 100 --repo "$REPO" --json databaseId,headBranch,status \
  --jq ".[] | select(.headBranch==\"$BRANCH\" and (.status==\"in_progress\" or .status==\"queued\")) | .databaseId" \
  | xargs -r -n1 gh run cancel --repo "$REPO"

echo "✅ Done."
