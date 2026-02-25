#!/usr/bin/env bash
set -euo pipefail
ROOT="."
OUT="repo_scan.json"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --root) ROOT="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

# Routes (Next app/pages) + generic route-ish files
rg -n --hidden --glob '!**/node_modules/**' -g 'app/**/page.*' -g 'pages/**/*.*' 'export default|function|const' "$ROOT"   | awk -F: '{print $1}' | sort -u > "$tmp/routes.txt" || true

# Navigation components
rg -n --hidden --glob '!**/node_modules/**' 'nav|sidebar|breadcrumb|tabs' "$ROOT"   | head -n 400 > "$tmp/nav_hits.txt" || true

# Tables/lists patterns
rg -n --hidden --glob '!**/node_modules/**' 'DataTable|tanstack/table|TableHead|TableRow|virtual|infinite' "$ROOT"   | head -n 400 > "$tmp/table_hits.txt" || true

# RBAC-ish
rg -n --hidden --glob '!**/node_modules/**' 'RBAC|role|permission|can\(|hasAccess|authorize|authz|policy' "$ROOT"   | head -n 400 > "$tmp/rbac_hits.txt" || true

# Data model hints
rg -n --hidden --glob '!**/node_modules/**' 'schema\.prisma|drizzle|zod|createTable|pgTable|supabase|openapi|swagger' "$ROOT"   | head -n 400 > "$tmp/model_hits.txt" || true

jq -n   --arg root "$ROOT"   --arg generated_at "$(date -Is)"   --slurpfile routes <(jq -R -s 'split("\n")|map(select(length>0))' "$tmp/routes.txt")   --rawfile nav_hits "$tmp/nav_hits.txt"   --rawfile table_hits "$tmp/table_hits.txt"   --rawfile rbac_hits "$tmp/rbac_hits.txt"   --rawfile model_hits "$tmp/model_hits.txt" '{
  root: $root,
  generated_at: $generated_at,
  routes: $routes[0],
  signals: {
    navigation: ($nav_hits | split("\n") | map(select(length>0)) | .[0:200]),
    tables: ($table_hits | split("\n") | map(select(length>0)) | .[0:200]),
    rbac: ($rbac_hits | split("\n") | map(select(length>0)) | .[0:200]),
    models: ($model_hits | split("\n") | map(select(length>0)) | .[0:200])
  }
}' > "$OUT"

echo "Wrote $OUT"
