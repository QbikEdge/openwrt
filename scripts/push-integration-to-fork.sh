#!/bin/sh
# Push an integration branch to your GitHub fork (SSH). Uses
# --force-with-lease when the branch already exists on the fork so others
# are not overwritten if they pushed in the meantime.
set -eu

FORK_REMOTE="${1:-mine-openwrt}"
BRANCH="${2:-bpi-r4-pro-merged}"

if ! git remote get-url "$FORK_REMOTE" >/dev/null 2>&1; then
	echo "Remote '$FORK_REMOTE' is not configured." >&2
	exit 1
fi

if git ls-remote --exit-code "$FORK_REMOTE" "refs/heads/$BRANCH" >/dev/null 2>&1; then
	REMOTE_SHA=$(git ls-remote "$FORK_REMOTE" "refs/heads/$BRANCH" | cut -f1)
	git push --force-with-lease="refs/heads/$BRANCH:$REMOTE_SHA" "$FORK_REMOTE" "$BRANCH"
else
	git push -u "$FORK_REMOTE" "$BRANCH"
fi
