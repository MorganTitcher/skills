# Tables + filters + inspectors: the backbone of enterprise UX

## Why it matters
Most complex apps are “find → triage → inspect → act”.
Tables are not just data dumps: they are decision engines.

## Checklist
- Column strategy: 5–9 default columns; the rest configurable.
- Sticky primary column (object identity + status).
- Filters:
  - quick filters (chips) for common slices,
  - advanced filters (builder) for power users,
  - saved views (name + share + default per role).
- Inspector:
  - opens without route change (optional),
  - shows grouped sections,
  - preserves scroll/selection state,
  - supports next/prev navigation within result set.
