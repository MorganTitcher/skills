--- name: ux-architecture-and-interaction-design
description: Generate and audit non-template UI/UX (IA, hierarchy, progressive disclosure, interaction contracts, and state completeness) using bash tools + an opinionated rulebook. Use when designing complex screens, improving information density without overload, or preventing hollow template UIs.
license: MIT
metadata:
  author: community
  version: "1.0.0"
argument-hint: |
  Optional args:
    --root <path> (repo root)
    --screen "<name>" (screen spec name)
    --files "<glob or rg pattern>" (files to audit)
---
# UX Architecture + Interaction Design Skill

This skill is built like top skills.sh examples: a short `SKILL.md` that points to **rules/** (opinionated guidance with good/bad examples) and **scripts/** (deterministic tooling). Inspired by the structure used in Vercel's skills such as `vercel-react-best-practices` and `web-design-guidelines`. citeturn6view1turn6view2

## When to Apply

Use this skill when the user wants **phenomenal UX** that avoids:
- shallow “template UI” layouts
- weak information hierarchy
- unclear interaction contracts
- missing states/error recovery
- “accordion dumping” instead of deliberate progressive disclosure

Common triggers:
- “Design / improve a dense table/list + detail experience”
- “Make this screen information-dense but not overwhelming”
- “Design a complex workflow (multi-step, approvals, RBAC, bulk ops)”
- “Audit our UI/UX beyond accessibility basics”

## What This Skill Produces

### A) Design Artifacts (structured, reviewable)
- IA map JSON (navigation nodes + “user questions” + cues)
- Screen spec JSON (regions, disclosure layers, state matrix, interactions, instrumentation)
- Rubric report JSON (scores + fix list)

### B) Audit Findings (actionable, not vibes)
- A prioritized “fix list” per screen/spec
- Optional `file:line` findings when auditing actual code surfaces

## Quick Start (Tooling)

> All scripts are **bash-first** and rely on `rg` + `jq`. Node is optional (for schema validation).

1) Check dependencies
```bash
./scripts/ux-check.sh
```

2) Scan repo for constraints (routes/components/RBAC signals)
```bash
./scripts/ux-scan.sh --root . --out artifacts/repo_scan.json
```

3) Create an IA scaffold (you edit/fill with domain objects)
```bash
./scripts/ux-ia.sh --product "My Product" --scan artifacts/repo_scan.json --out artifacts/ia_map.json
```

4) Create a screen spec scaffold (the “contract” for a screen)
```bash
./scripts/ux-screen.sh --screen "All Patients" --scan artifacts/repo_scan.json --out artifacts/screens/all_patients.json
```

5) Score + gate specs (refuse hollow specs)
```bash
./scripts/ux-rubric.sh --screens artifacts/screens --out artifacts/rubric_report.json
```

6) Optional: Audit real code files (heuristic checks + “UX smell” flags)
```bash
./scripts/ux-audit.sh --root . --files "app/|pages/|components/" --out artifacts/ux_audit.txt
```

7) Validate JSON outputs against schemas
```bash
./scripts/ux-validate.sh --file artifacts/screens/all_patients.json --schema schemas/screen_spec.schema.json
```

## How to Use (Agent Behavior)

When this skill is activated:

1. **Read `rules/00-orientation.md`** for the non-template mental model.
2. If a repo exists, run **ux-scan** to ground the work in constraints.
3. Generate artifacts (IA + Screen Spec).
4. Run **ux-rubric**. If anything critical fails, output a fix list first.
5. Only then propose layouts/components/interactions.

## Rulebook

Read individual rule files for detailed explanations and examples:

```text
rules/ia-information-scent.md
rules/hierarchy-attention-map.md
rules/disclosure-progressive.md
rules/interaction-contracts.md
rules/state-matrix.md
rules/density-without-overload.md
rules/tables-filters-and-inspectors.md
rules/bulk-ops-and-safety.md
rules/errors-and-recovery.md
rules/instrumentation-proof.md
```

Each rule file contains:
- Why it matters (the real failure mode)
- Bad example / Good example
- A checklist that can be used as acceptance criteria
- Optional detection heuristics (when code is available)

## Full Compiled Document

For the complete guide with all rules expanded: `references/AGENTS.md` (useful if you want this *always-on*). citeturn1view0
