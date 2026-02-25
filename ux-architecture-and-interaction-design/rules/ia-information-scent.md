# IA: Information scent (questions → cues → next actions)

## Why it matters
Users don't “read” navigation; they *hunt* using cues. Weak cues create thrash:
backtracking, pogo-sticking, and reliance on search for everything.

## Bad example
- Nav: “Overview / Details / Insights / Admin”
- No clear mapping to tasks, no clue where “the thing” lives.

## Good example
- Nav: “Patients / Providers / Claims / Authorizations / Reports”
- Each node states:
  - the user question it answers,
  - the dominant object,
  - the primary actions,
  - the “proof” cues (status, counts, recency, alerts).

## Checklist (acceptance criteria)
- Every nav item answers at least **one concrete question**.
- Labels match the user's object vocabulary.
- Each destination emits **proof cues** within 2 seconds (loading state allowed).
- “Next best action” is visible without scrolling for top tasks.

## Optional detection heuristics (code)
- Flag nav labels that are vague: Overview, Insights, Stuff, Tools, Manage
- Flag pages with no primary CTA in first viewport.
