# State completeness: the UI must survive reality

## Why it matters
Production data is missing, stale, permissioned, or inconsistent.
If you only design the happy path, your UI becomes hostile.

## Required states (minimum)
- loading
- empty (no results vs no access vs not configured)
- error (network, server, validation)
- partial (some sections unavailable)
- permission denied
- stale data / conflict (someone else changed it)

## Checklist
- Each state has:
  - user-facing explanation,
  - next step,
  - recovery path (retry, contact admin, adjust filters).
- “Empty” distinguishes:
  - empty because filters,
  - empty because none exist,
  - empty because not onboarded.

## Detection heuristics
- Look for TODO empty state, generic “Something went wrong”, missing retry.
