#!/usr/bin/env bash
set -euo pipefail
FILE=""
SCHEMA=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --file) FILE="$2"; shift 2;;
    --schema) SCHEMA="$2"; shift 2;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done
[[ -f "$FILE" ]] || { echo "--file not found: $FILE" >&2; exit 1; }
[[ -f "$SCHEMA" ]] || { echo "--schema not found: $SCHEMA" >&2; exit 1; }

if command -v node >/dev/null 2>&1; then
  npx --yes ajv-cli validate -s "$SCHEMA" -d "$FILE"
  echo "OK: schema valid ($FILE)"
else
  jq -e '.' "$FILE" >/dev/null
  echo "OK: JSON parses ($FILE) (node missing; schema not validated)" >&2
fi
