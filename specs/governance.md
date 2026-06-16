# Spec governance

## Authority

When two documents disagree, the higher tier wins:

1. `specs/governance.md` (this file)
2. System specs (`architecture`, `tech-stack`, `data-schema`, `accessibility`, …)
3. Feature specs (`specs/features/*`)
4. `docs/feature-inventory.md` (reality of the build)
5. `FutureIdeas/`, `docs/brainstorm.md` (non-authoritative)

## Rules

- **Spec before code** for any user-visible behavior or setting.
- Every feature spec ends with a **Verification** block: target release, last
  verified date, commit, primary code paths.
- New user-visible string → added to every bundled locale file in the same PR.
- New analytics/crash event → catalog entry + allowlist + mapping test.
- Brainstorm ideas are promoted to feature specs only when rules are locked.

## Verification block template

```
## Verification
- Target release: vX.Y
- Last verified: YYYY-MM-DD
- Commit: <hash>
- Primary code paths: Path/To/File.swift, ...
```
