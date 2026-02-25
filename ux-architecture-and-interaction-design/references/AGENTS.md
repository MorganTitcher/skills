# UX Architecture & Interaction Design (Always-on Index)

This is the “compiled” rulebook index, in the style of Vercel skills that reference `AGENTS.md` for the expanded document. citeturn6view1

## The anti-template thesis
Template UIs fail because they optimize for *layout* rather than *questions, decisions, and recovery*.
A great screen is a machine that:
1) answers the user’s question quickly,
2) makes the next best action obvious,
3) prevents expensive mistakes,
4) recovers gracefully when reality is messy.

## Core outputs you must be able to defend
- **User-question map**: What questions does the user bring to this screen?
- **Attention map**: What must dominate attention, what must recede?
- **Disclosure map**: What belongs in default view vs drill-in vs expert view?
- **Interaction contracts**: Trigger → system response → undo/recovery → edge cases
- **State matrix**: loading / empty / error / partial / permission / stale-data
- **Instrumentation proof**: what events prove the UI is working?

## Categories (priority order)
1) IA + Information Scent
2) Hierarchy + Attention
3) Progressive Disclosure
4) Interaction Contracts + Safety
5) State Completeness + Recovery
6) Density Without Overload
7) Instrumentation (prove it works)

See `rules/` for the detailed playbook, with bad/good examples and acceptance checklists.
