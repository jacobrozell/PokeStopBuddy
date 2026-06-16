# Specs index

Authoritative product & system specs. Behavior described here is the contract;
`docs/feature-inventory.md` describes what actually ships.

## Source-of-truth hierarchy

`governance.md` → system specs → feature specs → `docs/feature-inventory.md` →
`FutureIdeas/` (not authoritative).

## System specs

| Spec | Concern |
|------|---------|
| [`governance.md`](governance.md) | Conflict resolution, spec rules |
| [`architecture.md`](architecture.md) | Layers, dependency rules, module map |
| [`tech-stack.md`](tech-stack.md) | Frameworks, min OS, SDKs |
| [`design-system.md`](design-system.md) | Tokens, typography, semantic colors |
| [`data-schema.md`](data-schema.md) | Persistence model + migration policy |
| [`accessibility.md`](accessibility.md) | WCAG requirements + per-screen tracker |
| [`localization.md`](localization.md) | Locale policy |
| [`test-plan.md`](test-plan.md) | Test matrix + CI gates |
| [`feature-flags.md`](feature-flags.md) | Release surface & environment config |

## Feature specs

| Spec | Status |
|------|--------|
| [`features/content-generation.md`](features/content-generation.md) | shipped (v1.0) |
| [`features/submission-editor.md`](features/submission-editor.md) | shipped (v1.0) |
| [`features/submission-library.md`](features/submission-library.md) | shipped (v1.0) |
| [`features/quality-coach.md`](features/quality-coach.md) | shipped (v1.0) |
