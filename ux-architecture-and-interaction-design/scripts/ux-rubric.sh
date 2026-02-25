#!/usr/bin/env bash
set -euo pipefail
SCREENS_DIR=""
OUT="rubric_report.json"
THRESHOLD="${THRESHOLD:-4}" # out of 7 checks

while [[ $# -gt 0 ]]; do
  case "$1" in
    --screens) SCREENS_DIR="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done
[[ -d "$SCREENS_DIR" ]] || { echo "--screens dir required" >&2; exit 1; }

score_one(){
  local f="$1"
  local q layers states interactions attention instrumentation bulk
  q="$(jq -e '.intent.primary_user_question|test("^TODO")|not' "$f" >/dev/null 2>&1 && echo 1 || echo 0)"
  layers="$(jq -e '.disclosure_layers.layer0_default|length>0 and .disclosure_layers.layer2_expert|length>0' "$f" >/dev/null 2>&1 && echo 1 || echo 0)"
  states="$(jq -e '.states.loading and .states.empty and .states.error and .states.permission_denied and .states.stale_or_conflict' "$f" >/dev/null 2>&1 && echo 1 || echo 0)"
  interactions="$(jq -e '.interactions|length>=2' "$f" >/dev/null 2>&1 && echo 1 || echo 0)"
  attention="$(jq -e '.attention_map.primary|length>0 and .attention_map.tertiary|length>0' "$f" >/dev/null 2>&1 && echo 1 || echo 0)"
  instrumentation="$(jq -e '.instrumentation.events|length>=4' "$f" >/dev/null 2>&1 && echo 1 || echo 0)"
  bulk="$(jq -e '.bulk_ops.supported==true and .bulk_ops.safety|length>0' "$f" >/dev/null 2>&1 && echo 1 || echo 0)"

  local total=$((q+layers+states+interactions+attention+instrumentation+bulk))

  jq -n     --arg file "$(basename "$f")"     --arg screen "$(jq -r '.screen' "$f")"     --argjson score "$total"     --argjson threshold "$THRESHOLD"     --argjson checks "{
      user_question: $q,
      disclosure_layers: $layers,
      state_matrix: $states,
      interaction_contracts: $interactions,
      attention_map: $attention,
      instrumentation: $instrumentation,
      bulk_ops_safety: $bulk
    }"     '{
      file:$file,
      screen:$screen,
      score_out_of_7:$score,
      pass: ($score >= $threshold),
      checks:$checks,
      fix_list: [
        (if $checks.user_question==0 then "Define a non-TODO primary_user_question + success_definition (measurable)" else empty end),
        (if $checks.attention_map==0 then "Fill attention_map (primary/secondary/tertiary) to enforce hierarchy" else empty end),
        (if $checks.disclosure_layers==0 then "Populate disclosure layers with concrete elements + gating rules" else empty end),
        (if $checks.interaction_contracts==0 then "Add at least 2 interaction contracts with failure modes + recovery" else empty end),
        (if $checks.state_matrix==0 then "Complete state matrix incl stale/conflict; define recovery paths" else empty end),
        (if $checks.bulk_ops_safety==0 then "Specify bulk ops safety model (preview, permissions, undo/audit)" else empty end),
        (if $checks.instrumentation==0 then "Add events that prove UX works (latency, errors, funnels)" else empty end)
      ]
    }'
}

tmp="$(mktemp)"; trap 'rm -f "$tmp"' EXIT
for f in "$SCREENS_DIR"/*.json; do
  [[ -f "$f" ]] || continue
  score_one "$f" >> "$tmp"
done

jq -s --arg generated_at "$(date -Is)" '{
  generated_at:$generated_at,
  screens:.,
  summary:{
    count:length,
    avg_score:(if length==0 then 0 else (map(.score_out_of_7)|add/length) end),
    pass_count:(map(select(.pass==true))|length)
  }
}' "$tmp" > "$OUT"

echo "Wrote $OUT (threshold=$THRESHOLD)"
