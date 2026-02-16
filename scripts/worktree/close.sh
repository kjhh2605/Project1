#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/lib.sh"

require_cmd git

issue=""
track=""
slug=""
delete_branch="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --issue) issue="$2"; shift 2 ;;
    --track) track="$2"; shift 2 ;;
    --slug) slug="$2"; shift 2 ;;
    --delete-branch) delete_branch="true"; shift ;;
    *) die "unknown arg: $1" ;;
  esac
done

[[ -n "$issue" ]] || die "--issue is required"
[[ -n "$track" ]] || die "--track is required"
[[ -n "$slug" ]] || die "--slug is required"

slug="$(sanitize_slug "$slug")"
is_valid_track "$track" || die "track must be one of: fe|be|pf|platform"

ensure_root

key="${issue}-${track}-${slug}"
wt_dir="${ROOT_DIR}/worktrees/${key}"

[[ -d "$wt_dir" ]] || die "worktree not found: $wt_dir"

branch="$(git -C "$wt_dir" rev-parse --abbrev-ref HEAD)"
git worktree remove "$wt_dir"

echo "removed worktree: $wt_dir"

if [[ "$delete_branch" == "true" ]]; then
  git branch -D "$branch"
  echo "deleted branch: $branch"
else
  echo "kept branch: $branch"
fi
