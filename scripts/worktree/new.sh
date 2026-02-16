#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/lib.sh"

require_cmd git

issue=""
track=""
type=""
slug=""
task="feature"
base="develop"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --issue) issue="$2"; shift 2 ;;
    --track) track="$2"; shift 2 ;;
    --type) type="$2"; shift 2 ;;
    --slug) slug="$2"; shift 2 ;;
    --task) task="$2"; shift 2 ;;
    --base) base="$2"; shift 2 ;;
    *) die "unknown arg: $1" ;;
  esac
done

[[ -n "$issue" ]] || die "--issue is required"
[[ "$issue" =~ ^[0-9]+$ ]] || die "issue must be numeric"
[[ -n "$track" ]] || die "--track is required"
[[ -n "$type" ]] || die "--type is required"
[[ -n "$slug" ]] || die "--slug is required"

is_valid_track "$track" || die "track must be one of: fe|be|pf|platform"
is_valid_type "$type" || die "type must be one of: feat|hotfix|chore"
slug="$(sanitize_slug "$slug")"
[[ -n "$slug" ]] || die "slug became empty after sanitization"

ensure_root

if ! git show-ref --verify --quiet "refs/heads/${base}"; then
  if git show-ref --verify --quiet "refs/remotes/origin/${base}"; then
    git branch "$base" "origin/${base}" >/dev/null 2>&1 || true
  else
    base="main"
  fi
fi

branch="${type}/#${issue}/${track}-${slug}"
worktree_key="${issue}-${track}-${slug}"
worktree_dir="${ROOT_DIR}/worktrees/${worktree_key}"

if [[ -d "$worktree_dir" ]]; then
  die "worktree already exists: $worktree_dir"
fi

if git show-ref --verify --quiet "refs/heads/${branch}"; then
  git worktree add "$worktree_dir" "$branch"
else
  git worktree add -b "$branch" "$worktree_dir" "$base"
fi

mkdir -p "${worktree_dir}/docs/handoffs"
handoff_file="${worktree_dir}/docs/handoffs/${worktree_key}.md"
cat > "$handoff_file" <<EOT
# HANDOFF ${worktree_key}

## Goal
-

## Status
- done:
- in-progress:
- todo:

## Tried/Result
- command:
  - result:

## Failures to avoid
-

## Next steps
1.

## Verification commands
- make lint
- make test

## Open assumptions
-
EOT

cp "$handoff_file" "${worktree_dir}/HANDOFF.md"

workplan_file="${worktree_dir}/WORKPLAN.md"
if [[ -x "${ROOT_DIR}/scripts/vibe/select-skills.sh" ]]; then
  "${ROOT_DIR}/scripts/vibe/select-skills.sh" \
    --task-type "$task" \
    --tracks "$track" \
    --parallel true \
    --output "$workplan_file"
else
  cat > "$workplan_file" <<EOT
# WORKPLAN ${worktree_key}

## Skills
- vibe-requirements-clarifier
- vibe-success-criteria-planner
- vibe-parallel-worktree-orchestrator
- vibe-context-handoff-manager
- vibe-surgical-change-guard
- vibe-verification-matrix
- vibe-git-pr-safety-flow
EOT
fi

echo "created branch: ${branch}"
echo "worktree: ${worktree_dir}"
echo "handoff: ${handoff_file}"
echo "workplan: ${workplan_file}"
