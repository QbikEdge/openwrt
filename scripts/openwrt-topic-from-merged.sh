#!/bin/sh
# Start a clean topic branch from official OpenWrt for upstream submission.
# Use bpi-r4-pro-merged (or similar) only for integration/build; cherry-pick
# logical commits onto this branch instead of opening one mega-merge PR.
set -eu

UP_REMOTE="${1:-openwrt-main}"
UP_BRANCH="${2:-main}"
TOPIC="${3:-r4pro-upstream-topic}"

git fetch "$UP_REMOTE" "$UP_BRANCH"
if git show-ref --verify --quiet "refs/heads/$TOPIC"; then
	echo "Branch $TOPIC already exists; delete it or pick another name." >&2
	exit 1
fi
git switch -c "$TOPIC" "$UP_REMOTE/$UP_BRANCH"
printf '\nCreated %s at %s/%s.\nCherry-pick from your integration branch, e.g.:\n  git cherry-pick <sha>\n' \
	"$TOPIC" "$UP_REMOTE" "$UP_BRANCH"
