#!/usr/bin/env bash
set -euo pipefail
ROOT="."
FILES=""
OUT="ux_audit.txt"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root) ROOT="$2"; shift 2;;
    --files) FILES="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done
[[ -n "$FILES" ]] || { echo "--files required (rg pattern or path prefix)" >&2; exit 1; }

# This audit is heuristic: it flags common UX failure smells, not accessibility.
# Output is intentionally actionable and terse (file:line: message).

tmp="$(mktemp)"; trap 'rm -f "$tmp"' EXIT

# Smell: generic errors
rg -n --hidden --glob '!**/node_modules/**' -S 'Something went wrong|Unknown error|Error occurred' "$ROOT" | rg -n "$FILES"   | awk -F: '{print $1 ":" $2 ": Generic error copy — add cause + next step + recovery"}' >> "$tmp" || true

# Smell: missing empty states (very heuristic)
rg -n --hidden --glob '!**/node_modules/**' -S 'return null;|<></>|<Fragment></Fragment>' "$ROOT" | rg -n "$FILES"   | awk -F: '{print $1 ":" $2 ": Potential silent empty state — ensure explicit empty/loading/error UI"}' >> "$tmp" || true

# Smell: destructive actions without confirmation (heuristic keywords)
rg -n --hidden --glob '!**/node_modules/**' -S 'delete|remove|destroy' "$ROOT" | rg -n "$FILES"   | rg -v 'confirm|Are you sure|undo|toast'   | awk -F: '{print $1 ":" $2 ": Destructive action keyword — verify confirmation + undo/audit trail"}' >> "$tmp" || true

# Smell: accordions everywhere
rg -n --hidden --glob '!**/node_modules/**' -S 'Accordion|Disclosure' "$ROOT" | rg -n "$FILES"   | awk -F: '{print $1 ":" $2 ": Accordion/disclosure used — ensure progressive disclosure is deliberate (not dumping ground)"}' >> "$tmp" || true

sort -u "$tmp" > "$OUT"
echo "Wrote $OUT"
