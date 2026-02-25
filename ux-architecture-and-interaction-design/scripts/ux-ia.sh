#!/usr/bin/env bash
set -euo pipefail
PRODUCT=""
SCAN=""
OUT="ia_map.json"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --product) PRODUCT="$2"; shift 2;;
    --scan) SCAN="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done
[[ -n "$PRODUCT" ]] || { echo "--product required" >&2; exit 1; }
[[ -f "$SCAN" ]] || { echo "--scan not found: $SCAN" >&2; exit 1; }

# Heuristic: create nav candidates from common enterprise objects + detected route hints
jq -n   --arg product "$PRODUCT"   --arg generated_at "$(date -Is)"   --argjson detected_routes "$(jq '.routes' "$SCAN")" '{
  product: $product,
  generated_at: $generated_at,
  nav: [
    {
      id: "home",
      label: "Home",
      user_questions: ["What needs attention right now?", "What changed since last visit?"],
      cues: ["alerts", "assigned items", "recent activity", "exceptions"],
      primary_actions: ["global search", "resume work", "review exceptions"]
    },
    {
      id: "objects",
      label: "Objects (rename to domain nouns)",
      user_questions: ["Where is X?", "What is the status of X?", "What requires action?"],
      cues: ["status chips", "counts by state", "saved views", "bulk selection"],
      primary_actions: ["filter", "open inspector", "bulk action"]
    },
    {
      id: "reports",
      label: "Reports",
      user_questions: ["What trends matter?", "Where are we failing?", "What improved?"],
      cues: ["time ranges", "cohorts", "drilldowns", "export"],
      primary_actions: ["change time range", "save report", "export"]
    }
  ],
  detected_routes: $detected_routes,
  notes: [
    "Replace 'Objects' with real domain nouns (patients/claims/providers/etc.).",
    "For each nav item: define questions + cues + primary actions (information scent).",
    "Avoid vague labels like Overview/Insights unless paired with explicit cues and objects."
  ]
}' > "$OUT"
echo "Wrote $OUT"
