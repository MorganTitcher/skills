#!/usr/bin/env bash
set -euo pipefail
need(){ command -v "$1" >/dev/null 2>&1 || { echo "Missing dependency: $1" >&2; exit 1; }; }
need rg
need jq
echo "OK: rg + jq present."
if command -v node >/dev/null 2>&1; then
  echo "OK: node present (schema validation via ajv available via npx)."
else
  echo "Note: node missing; schema validation will fall back to JSON parse only." >&2
fi
