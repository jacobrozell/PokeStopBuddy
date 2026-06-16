# Agent Build Checklist — PokeStop Buddy (0 → Ship)

Adapted from the domain-agnostic iOS build checklist. Keep **spec-first**,
**accessibility gate**, and **release-surface gating** — they transfer to every app.
The full reusable **agent prompt library** (a11y audits, user scenarios, release
gates, architecture reviews) lives in the original checklist; trigger phrases:
*accessibility audit, user scenario, release gate, architecture review*.

## Owner decisions (locked)

| Decision | Value |
|----------|-------|
| App name / bundle | PokeStop Buddy / `com.pokestopbuddy.app` |
| Min iOS | 17.0 |
| Content generation | Offline template engine (`ContentGenerating`) |
| Bundled locales | `en` (parity files kept for CI) |
| Telemetry | off in v1.0 |
| Tip/donate link | hidden (`AppLinks.tipJar == nil`) |

## Phase status

| Phase | Title | Status |
|-------|-------|--------|
| 0 | Repo & agent infrastructure | ✅ done |
| 1 | Spec system from brainstorm | ✅ done |
| 2 | Design system & a11y foundations | ✅ done |
| 3 | Domain layer (test-first) | ✅ done |
| 4 | Persistence & repositories | ✅ done |
| 5 | App shell & navigation | ✅ done |
| 6 | First vertical slice (core journey) | ✅ done |
| 7 | Shared chrome & adaptive layout | ✅ iPad split + two-column editor, idiom-aware predicates (tested) |
| 8 | Entity management & settings | 🟡 partial (settings ✅) |
| 9 | Lists, history & derived views | 🟡 partial (library ✅) |
| 10 | Localization & text coverage | 🟡 `en` only |
| 11 | Accessibility hardening (gate) | 🔜 needs sim/device |
| 12 | Test matrix & CI | 🟡 unit/a11y in place; CI workflow TODO |
| 13 | Release surface & lean ship | ✅ surface module in place |
| 14 | Telemetry, deep links, extensions | 🔜 facade only |
| 15 | Legal pages & store URLs | 🟡 HTML stubs |
| 16 | Release QA & ship | 🔜 needs macOS/device |

## Progress log

| Phase | Completed | Commit | Notes |
|-------|-----------|--------|-------|
| 0 | 2026-06-16 | initial | XcodeGen, lint, hooks, mcp, contributing |
| 1 | 2026-06-16 | initial | governance + system + feature specs |
| 2 | 2026-06-16 | initial | tokens + accessible components |
| 3 | 2026-06-16 | initial | generator + evaluator + tests |
| 4 | 2026-06-16 | initial | repo protocol + in-memory + SwiftData |
| 5 | 2026-06-16 | initial | app shell, DI, router |
| 6 | 2026-06-16 | initial | editor vertical slice + library |
| 7 | 2026-06-16 | adaptive | iPad NavigationSplitView, two-column editor, LayoutContext predicates + tests, landscape UI smoke |

## What needs a Mac (cannot be done in this Linux session)

- `xcodegen generate` + `xcodebuild build/test` (compile verification).
- Simulator/VoiceOver manual a11y audits (Phase 11).
- TestFlight / archive (Phase 15–16).

These are the next actions for a macOS CI runner or local Xcode.
