#!/usr/bin/env bash
# Applies the organization's settings to one Ruchoir repository, then prints what it now holds.
#
# Usage: configure-repo.sh <repository> "<description>" [topic...]
#
# Needs `gh`, signed in with an account that administers the repository. Safe to run again: every
# setting is set, never toggled.
#
# - Merges: squash only, the pull request title becomes the commit, branches deleted on merge.
# - No wiki, projects or issues: work is tracked in Linear.
# - Topics: `ruchoir` plus the given ones.
# - Protection of `main` (pull request required, `conventions` check required, conversations
#   resolved, no force push, no deletion, no review required): GitHub Free offers it on public
#   repositories only, so a private one is reported and left as it is.

set -euo pipefail

repo="${1:?usage: configure-repo.sh <repository> \"<description>\" [topic...]}"
description="${2:?usage: configure-repo.sh <repository> \"<description>\" [topic...]}"
shift 2
full="Ruchoir/$repo"

gh api -X PATCH "repos/$full" \
  -F allow_squash_merge=true \
  -F allow_merge_commit=false \
  -F allow_rebase_merge=false \
  -F delete_branch_on_merge=true \
  -f squash_merge_commit_title=PR_TITLE \
  -f squash_merge_commit_message=PR_BODY \
  -F has_wiki=false \
  -F has_projects=false \
  -F has_issues=false \
  -f description="$description" > /dev/null

topics=(-f "names[]=ruchoir")
for topic in "$@"; do
  topics+=(-f "names[]=$topic")
done
gh api -X PUT "repos/$full/topics" "${topics[@]}" > /dev/null

visibility="$(gh api "repos/$full" --jq .visibility)"
if [ "$visibility" != public ]; then
  echo "$full: protection unavailable on a private repository with GitHub Free, main is not protected"
elif ! gh api "repos/$full/branches/main" > /dev/null 2>&1; then
  echo "$full: no main branch yet, run this again after the first push to protect it"
else
  gh api -X PUT "repos/$full/branches/main/protection" --input - > /dev/null <<'JSON'
{
  "required_status_checks": { "strict": false, "contexts": ["conventions / Repository conventions"] },
  "enforce_admins": false,
  "required_pull_request_reviews": { "required_approving_review_count": 0 },
  "restrictions": null,
  "required_conversation_resolution": true,
  "allow_force_pushes": false,
  "allow_deletions": false
}
JSON
  echo "$full: main protected"
fi

gh api "repos/$full" --jq '{name, visibility, allow_squash_merge, allow_merge_commit, allow_rebase_merge, delete_branch_on_merge, has_issues, has_wiki, has_projects, description, topics}'
