#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/lib.sh"

require_cmd git
ensure_root

git fetch --all --prune

git worktree list --porcelain | awk '/^worktree /{print $2}' | while read -r wt; do
  if [[ -d "$wt/.git" || -f "$wt/.git" ]]; then
    branch="$(git -C "$wt" rev-parse --abbrev-ref HEAD)"
    echo "[$wt] branch=${branch}"
    git -C "$wt" status --short --branch
  fi
done
