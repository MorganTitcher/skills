# Interaction contracts: Trigger → response → undo/recovery

## Why it matters
UI is a promise. Without explicit contracts, you get:
- surprise latency, double submits, partial saves,
- irreversible destructive actions,
- inconsistent validation and no recovery path.

## Contract template
- Trigger (what user does)
- Preconditions (what must be true)
- System response (immediate, within 100ms)
- Async behavior (spinner, skeleton, optimistic update?)
- Success feedback (what changed that proves it worked)
- Undo window (if applicable)
- Failure modes + recovery (network, validation, permissions, conflicts)

## Checklist
- Every primary action has a contract.
- Every destructive action has confirmation + undo or “are you sure?” + audit trail.
- Latency budgets are defined (e.g., 300ms: optimistic; >800ms: skeleton).
