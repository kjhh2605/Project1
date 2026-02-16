#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

err() {
  echo "[worktree] $*" >&2
}

die() {
  err "$*"
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "missing command: $1"
}

is_valid_track() {
  case "$1" in
    fe|be|pf|platform) return 0 ;;
    *) return 1 ;;
  esac
}

is_valid_type() {
  case "$1" in
    feat|hotfix|chore) return 0 ;;
    *) return 1 ;;
  esac
}

sanitize_slug() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9._-]+/-/g' | sed -E 's/^-+|-+$//g'
}

ensure_root() {
  cd "$ROOT_DIR"
}
