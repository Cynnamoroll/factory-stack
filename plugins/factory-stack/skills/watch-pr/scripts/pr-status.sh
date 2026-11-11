#!/usr/bin/env bash
# Usage: pr-status.sh <pr-number-or-url> [--watch] [--interval SECONDS] [--timeout SECONDS]
# Prints one JSON object describing whether the PR can merge.
# With --watch, polls until the verdict is no longer PENDING, the head commit
# changes, or the timeout passes, then prints the final object.
# Verdicts: MERGED, CLOSED, CONFLICT, CI_FAILING, CHANGES_REQUESTED, THREADS,
# PENDING, WAITING_REVIEW, READY.
set -euo pipefail

pr=""
watch=0
interval=60
timeout=3600
while [ "$#" -gt 0 ]; do
	case "$1" in
		--watch) watch=1 ;;
		--interval) interval=$2; shift ;;
		--timeout) timeout=$2; shift ;;
		-*) echo "unknown option: $1" >&2; exit 64 ;;
		*) pr=$1 ;;
	esac
	shift
done
[ -n "$pr" ] || { echo "usage: pr-status.sh <pr> [--watch] [--interval S] [--timeout S]" >&2; exit 64; }
command -v gh >/dev/null || { echo "gh not found" >&2; exit 2; }
command -v jq >/dev/null || { echo "jq not found" >&2; exit 2; }

status_json() {
	local view threads
	view=$(gh pr view "$pr" --json number,url,state,isDraft,mergeable,mergeStateStatus,reviewDecision,headRefOid,statusCheckRollup)
	threads=$(gh api graphql -F owner='{owner}' -F repo='{repo}' -F number="$(jq -r .number <<<"$view")" -f query='
		query($owner: String!, $repo: String!, $number: Int!) {
			repository(owner: $owner, name: $repo) {
				pullRequest(number: $number) {
					reviewThreads(first: 100) { nodes { isResolved comments(first: 1) { nodes { author { login } path } } } }
				}
			}
		}' --jq '[.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false) | {author: .comments.nodes[0].author.login, path: .comments.nodes[0].path}]')
	jq -c --argjson threads "$threads" '
		def bad: (.conclusion // .state // "") as $c
			| ["FAILURE","CANCELLED","TIMED_OUT","ACTION_REQUIRED","STARTUP_FAILURE","ERROR"] | index($c) != null;
		def pending: ((.status // "") as $s | ["QUEUED","IN_PROGRESS","PENDING","WAITING","REQUESTED"] | index($s) != null)
			or ((.state // "") == "PENDING" or (.state // "") == "EXPECTED");
		(.statusCheckRollup // []) as $checks
		| ([$checks[] | select(bad) | (.name // .context)]) as $failing
		| ([$checks[] | select(pending) | (.name // .context)]) as $pending
		| {
			pr: .number, url: .url, head: .headRefOid, state: .state, draft: .isDraft,
			mergeable: .mergeable, merge_state: .mergeStateStatus, review: .reviewDecision,
			failing_checks: $failing, pending_checks: $pending, unresolved_threads: $threads,
			verdict: (
				if .state == "MERGED" then "MERGED"
				elif .state == "CLOSED" then "CLOSED"
				elif .mergeable == "CONFLICTING" then "CONFLICT"
				elif ($failing | length) > 0 then "CI_FAILING"
				elif .reviewDecision == "CHANGES_REQUESTED" then "CHANGES_REQUESTED"
				elif ($threads | length) > 0 then "THREADS"
				elif ($pending | length) > 0 or .mergeable == "UNKNOWN" then "PENDING"
				elif .reviewDecision == "REVIEW_REQUIRED" or .isDraft then "WAITING_REVIEW"
				elif .mergeStateStatus == "CLEAN" or .mergeStateStatus == "HAS_HOOKS" or .mergeStateStatus == "UNSTABLE" then "READY"
				else "PENDING" end)
		}' <<<"$view"
}

current=$(status_json)
if [ "$watch" -eq 0 ]; then
	echo "$current"
	exit 0
fi

start_head=$(jq -r .head <<<"$current")
deadline=$(( $(date +%s) + timeout ))
while [ "$(jq -r .verdict <<<"$current")" = "PENDING" ] && [ "$(date +%s)" -lt "$deadline" ]; do
	sleep "$interval"
	current=$(status_json)
	[ "$(jq -r .head <<<"$current")" = "$start_head" ] || break
done
echo "$current"
