#!/usr/bin/env bash
set -euo pipefail
SCREEN=""
SCAN=""
OUT="screen.json"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --screen) SCREEN="$2"; shift 2;;
    --scan) SCAN="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done
[[ -n "$SCREEN" ]] || { echo "--screen required" >&2; exit 1; }
[[ -f "$SCAN" ]] || { echo "--scan not found: $SCAN" >&2; exit 1; }

jq -n   --arg screen "$SCREEN"   --arg generated_at "$(date -Is)"   --argjson scan "$(cat "$SCAN")" '{
  screen: $screen,
  generated_at: $generated_at,

  intent: {
    primary_user_question: "TODO: single dominant question this screen answers (e.g., \"Which items need action now?\")",
    secondary_questions: [
      "TODO: what exceptions matter?",
      "TODO: what is blocking progress?"
    ],
    success_definition: "TODO: measurable (time-to-decision, error rate, completion rate)"
  },

  layout: {
    regions: [
      { id:"topbar", purpose:"identity + context + global actions", contains:["breadcrumb","title","global search","primary CTA"] },
      { id:"decision_surface", purpose:"scan/triage surface", contains:["table/list","status chips","quick filters","bulk selection"] },
      { id:"inspector", purpose:"deep detail without losing context", contains:["grouped sections","history","notes","next/prev navigation"] }
    ]
  },

  attention_map: {
    primary: ["object identity","status","next required action"],
    secondary: ["secondary facts that explain status","timestamps","assignees"],
    tertiary: ["diagnostics","raw payloads","admin-only controls"]
  },

  disclosure_layers: {
    layer0_default: [
      "5–9 primary columns/fields only",
      "quick filters as chips",
      "safe primary actions (no destructive by default)"
    ],
    layer1_contextual: [
      "inspector panel with grouped sections",
      "inline history/timeline",
      "expand row for rare-but-important fields"
    ],
    layer2_expert: [
      "bulk operations + dry-run preview",
      "diagnostics/raw payloads",
      "admin tools (role gated)"
    ]
  },

  states: {
    loading: { ui:"skeleton on decision surface; keep filters interactive", timeout_ms: 8000 },
    empty: { ui:"explain why empty (filters vs none exist vs not onboarded) + CTA", variants:["no_results","none_exist","not_configured"] },
    error: { ui:"error summary + retry; preserve user input; log event", types:["network","server","validation"] },
    partial: { ui:"render available blocks; mark unavailable blocks; allow retry per block" },
    permission_denied: { ui:"explain missing permission + request access path" },
    stale_or_conflict: { ui:"detect conflict; offer refresh/merge; preserve local edits" }
  },

  interactions: [
    {
      name: "open_inspector",
      trigger: "click row",
      preconditions: ["row is selectable","user has read permission"],
      response: {
        immediate: "highlight selection + open inspector shell",
        async: "fetch details; stream sections as ready"
      },
      success_proof: ["inspector shows identity + status within first paint"],
      failure_modes: [
        { type:"permission", recovery:"show permission_denied state in inspector" },
        { type:"network", recovery:"retry detail fetch; keep list usable" }
      ]
    },
    {
      name: "primary_action",
      trigger: "click primary CTA",
      preconditions: ["required fields present"],
      response: { immediate:"disable button + show progress", async:"submit; optimistic update if safe" },
      undo: { supported:true, window_ms: 8000, method:"toast undo" },
      failure_modes: [
        { type:"validation", recovery:"inline errors near fields + summary" },
        { type:"conflict", recovery:"show stale_or_conflict with refresh/merge options" }
      ]
    }
  ],

  bulk_ops: {
    supported: true,
    safety: ["preview impact", "respect per-item permissions", "undo or audit trail"],
    long_running: { uses_jobs: true, progress_ui:"job toast + status page link" }
  },

  instrumentation: {
    events: [
      { name:"screen_view", properties:["screen","role","entry_path","active_filters"] },
      { name:"row_selected", properties:["screen","row_state","has_exceptions"] },
      { name:"primary_action_attempted", properties:["screen","action","role"] },
      { name:"primary_action_succeeded", properties:["screen","action","latency_ms"] },
      { name:"error_shown", properties:["screen","surface","type"] }
    ]
  },

  open_questions: [
    "What are the top 3 saved views users need?",
    "Which statuses are mutually exclusive and must be visually distinct?",
    "Which actions are risky and require confirmations/undo?"
  ]
}' > "$OUT"
echo "Wrote $OUT"
