# Orientation: The non-template workflow

## The failure you are preventing
A “template UI” looks fine but collapses under real use because:
- it doesn’t encode the user’s question(s),
- it lacks a hierarchy/attention strategy,
- it hides complexity in arbitrary accordions,
- it omits error recovery and partial data realities,
- it has no safety model for destructive or bulk actions,
- it cannot be validated (no rubric, no acceptance criteria).

## The workflow (repeatable)
1) Define **objects + states** (domain reality).
2) Define **user questions** per screen (what are they trying to learn/decide?).
3) Build an **attention map** (primary vs secondary vs tertiary).
4) Choose a **disclosure strategy** (default/drill-in/expert).
5) Specify **interaction contracts** (including undo + failures).
6) Enumerate the **state matrix** (including stale/partial/permission).
7) Add **instrumentation** (events that prove UX works).
8) Run a rubric gate; fix failures before visual polish.

If any step is missing, do not “move on” to layout.
