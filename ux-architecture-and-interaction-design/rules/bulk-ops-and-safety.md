# Bulk operations + safety model

## Why it matters
Bulk ops are where teams save time — and where they destroy data.
A good system makes power safe.

## Checklist
- Bulk selection is obvious (checkbox column + count).
- Dry-run / preview of impact (X items will change).
- Permissions respected per item (partial failure explained).
- Undo for reversible ops, or an audit trail + “revert” path.
- Rate limits / background job status for long ops.
