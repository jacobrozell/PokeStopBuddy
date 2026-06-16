# Test plan & CI gates

| Layer | Proves | Where |
|-------|--------|-------|
| Unit | Domain logic, ViewModel behavior | `Tests/Unit` |
| Accessibility | token contrast, label/identifier contracts | `Tests/Accessibility` |
| UI (XCUITest) | wiring, navigation, one smoke per journey | `Tests/UI` |

## Schemes

- **`PokeStopBuddyCI`** (PR gate): unit + accessibility only — minutes, not hours.
- **`PokeStopBuddy`** (full): + UI tests; run nightly.

## Launch arguments (UI tests)

| Arg | Effect |
|-----|--------|
| `-uitest-reset` | start with empty store |
| `-uitest-seed` | seed deterministic fixtures |
| `-disable-telemetry` | force telemetry off |
| `-enable_full_product_surface` | reveal gated/in-progress surface |

## Test doubles

`InMemorySubmissionRepository`, a deterministic clock, and the offline
`TemplateContentGenerator` (already deterministic) cover most needs without a sim.

## Verification
- Target release: v1.0
- Last verified: 2026-06-16
- Commit: (initial scaffold)
- Primary code paths: Tests/, project.yml
