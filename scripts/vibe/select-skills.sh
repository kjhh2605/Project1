#!/usr/bin/env bash
set -euo pipefail

task_type=""
tracks=""
parallel="false"
output=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --task-type) task_type="$2"; shift 2 ;;
    --tracks) tracks="$2"; shift 2 ;;
    --parallel) parallel="$2"; shift 2 ;;
    --output) output="$2"; shift 2 ;;
    *) echo "unknown arg: $1" >&2; exit 1 ;;
  esac
done

[[ -n "$task_type" ]] || { echo "--task-type required" >&2; exit 1; }
[[ -n "$tracks" ]] || { echo "--tracks required" >&2; exit 1; }

skills=()
add_skill() {
  local s="$1"
  for existing in "${skills[@]-}"; do
    [[ "$existing" == "$s" ]] && return 0
  done
  skills+=("$s")
}

add_skill "vibe-requirements-clarifier"
add_skill "vibe-success-criteria-planner"

if [[ "$parallel" == "true" ]]; then
  add_skill "vibe-parallel-worktree-orchestrator"
  add_skill "vibe-context-handoff-manager"
fi

IFS=',' read -ra track_arr <<< "$tracks"
for t in "${track_arr[@]-}"; do
  case "$t" in
    fe) add_skill "vibe-nextjs-fsd-boundary" ;;
    be) add_skill "vibe-go-hexagonal-architecture" ;;
    pf) add_skill "vibe-backend-lifecycle-di" ;;
    platform) add_skill "vibe-monorepo-turborepo-ops" ;;
  esac
done

case "$task_type" in
  api-change) add_skill "vibe-api-contract-first" ;;
  refactor) add_skill "vibe-debt-firebreak-architecture" ;;
  ops) add_skill "vibe-fullstack-quality-gates" ;;
  feature|bugfix) ;;
  *) echo "unsupported task type: $task_type" >&2; exit 1 ;;
esac

add_skill "vibe-tdd-implementation-loop"
add_skill "vibe-surgical-change-guard"
add_skill "vibe-verification-matrix"
add_skill "vibe-git-pr-safety-flow"

verification=(
  "make lint"
  "make test"
  "make ci"
)

render() {
  local target_tracks="$tracks"
  cat <<EOT
# WORKPLAN

## Inputs
- task_type: ${task_type}
- tracks: ${target_tracks}
- parallel: ${parallel}

## Skill Order
EOT
  for s in "${skills[@]-}"; do
    echo "- ${s}"
  done
  cat <<EOT

## Verification Commands
EOT
  for c in "${verification[@]-}"; do
    echo "- ${c}"
  done
}

if [[ -n "$output" ]]; then
  mkdir -p "$(dirname "$output")"
  render > "$output"
  echo "wrote ${output}"
else
  render
fi
