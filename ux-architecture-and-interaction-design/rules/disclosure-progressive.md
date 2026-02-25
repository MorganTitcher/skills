# Progressive disclosure: Default vs Drill-in vs Expert

## Why it matters
“Accordion dumping” hides critical info and forces users to open everything.
Good disclosure stages complexity to match task frequency and risk.

## Bad example
- Everything collapsed into 10 accordions; users must remember where each field lives.
- Expert controls mixed into default UI.

## Good example (3 layers)
- Layer 0 (default): high-frequency fields + safe actions.
- Layer 1 (contextual): inspector with grouped sections, history, attachments.
- Layer 2 (expert): diagnostics, raw payloads, bulk tools, admin-only.

## Checklist
- Every field/control has an assigned layer (0/1/2) with a justification:
  frequency, risk, role.
- Drill-in keeps navigation context (side panel, split view, modal w/ breadcrumb).
- Expert layer is gated by role or explicit “advanced” toggle.

## Detection heuristics
- Flag screens where >60% of content is hidden behind accordions by default.
