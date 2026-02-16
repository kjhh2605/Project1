#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

validate_file() {
  local f="$1"
  [[ -f "$f" ]] || return 0

  local required=(
    "## Goal"
    "## Status"
    "## Tried/Result"
    "## Failures to avoid"
    "## Next steps"
    "## Verification commands"
    "## Open assumptions"
  )

  for marker in "${required[@]}"; do
    if ! grep -q "^${marker}$" "$f"; then
      echo "missing section '${marker}' in ${f}" >&2
      return 1
    fi
  done

  if ! awk '/^## Verification commands/{flag=1;next}/^## /{flag=0}flag && /^- /{found=1}END{exit found?0:1}' "$f"; then
    echo "missing verification command bullets in ${f}" >&2
    return 1
  fi

  return 0
}

status=0

if [[ $# -gt 0 ]]; then
  for target in "$@"; do
    validate_file "$target" || status=1
  done
else
  while IFS= read -r file; do
    validate_file "$file" || status=1
  done < <(find "$ROOT_DIR/docs/handoffs" -type f -name '*.md' 2>/dev/null | sort)
fi

exit $status
