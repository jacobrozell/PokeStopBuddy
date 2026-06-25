# Waypoint Writer

An iOS app to quickly draft, generate, and fine-tune **Wayspot / Niantic Wayfarer submission** content — titles, descriptions, and supporting statements — and iterate on them until they're submission-ready.

**Status:** TestFlight prep · v1.0.0 (build 2) · **Branch:** `main` · Rebrand from PokeStopBuddy

> Product behavior lives in [`specs/`](specs/). This README is the build/run entry point. For what ships today see [`docs/feature-inventory.md`](docs/feature-inventory.md).

---

## What it does

- **Submission editor** — create, generate, iterate, and save Wayfarer drafts with version history
- **Template content engine** — offline, deterministic generation (LLM swappable behind `ContentGenerating`)
- **Quality coach** — live scoring via `SubmissionQualityEvaluator` in the editor
- **Submission library** — list, detail, delete saved drafts
- **Copy / share** — hand off content into Wayfarer via Copy All or ShareLink
- **Submission guide** — process, fields, categories, eligibility (placeholder GO assets)
- **Adaptive layout** — iPad split view and two-column editor
- **Preferences** — appearance and new-submission defaults

**Gated (post-1.0):** photo composition guidance, LLM enhance, export pack, telemetry — launch with `-enable_full_product_surface` to test locally.

---

## Requirements

- macOS with Xcode 15+ (iOS 17 SDK)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)
- [SwiftLint](https://github.com/realm/SwiftLint) (`brew install swiftlint`)

| | |
|--|--|
| **Bundle ID** | `com.jacobrozell.waypointwriter` |
| **Min iOS** | 17.0 |
| **Locales** | `en` only (parity files kept for CI) |
| **Telemetry** | Off in v1.0 |
| **Tip jar** | Hidden |

---

## Build & run

```bash
xcodegen generate
open WaypointWriter.xcodeproj   # or open generated project from XcodeGen output

# Build
xcodebuild build \
  -scheme WaypointWriterCI \
  -destination 'platform=iOS Simulator,name=iPhone 17'

# PR test suite (unit + accessibility)
xcodebuild test \
  -scheme WaypointWriterCI \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

Signing uses team `7JT2JB89AV`.

---

## Architecture

```
Features (SwiftUI + MVVM)
        │  depends on
        ▼
Domain (pure logic)  ◄── Data (repository protocols)
        ▲                        │ implemented by
        │                        ▼
        └───────────────  Persistence (SwiftData SchemaV1)
```

**Hard rules:** Domain never imports SwiftUI or SwiftData. Features depend on protocols, not concrete persistence. See [`CONTRIBUTING.md`](CONTRIBUTING.md).

---

## Project layout

| Folder | Responsibility |
|--------|----------------|
| `App/` | `@main` entry, dependency bootstrap, root navigation |
| `Features/` | SwiftUI + MVVM, one folder per flow |
| `Domain/` | Pure business logic — no SwiftUI, no persistence frameworks |
| `Data/` | Repository protocols + implementations |
| `Persistence/` | SwiftData schema, migrations, container factory |
| `DesignSystem/` | Tokens, reusable accessible components |
| `Support/` | Logging, feature flags, release surface, utilities |
| `Resources/` | Assets, strings, plist templates |
| `Tests/` | `Unit/`, `Accessibility/`, `UI/` |
| `specs/` | Authoritative product/system specs |
| `docs/` | Inventory, plans, legal HTML, checklist |

---

## Tests & CI

GitHub Actions on push/PR: SwiftLint + `WaypointWriterCI` unit and accessibility tests. UI tests cover smoke journeys and iPad landscape.

---

## Documentation map

| Doc | Purpose |
|-----|---------|
| [`docs/agent-build-checklist.md`](docs/agent-build-checklist.md) | Phased build checklist (0→Ship) |
| [`docs/feature-inventory.md`](docs/feature-inventory.md) | Shipped vs partial vs planned |
| [`docs/release/release_checklist.md`](docs/release/release_checklist.md) | Pre-submit gate |
| [`docs/release/app-store-listing.md`](docs/release/app-store-listing.md) | App Store copy |
| [`CHANGELOG.md`](CHANGELOG.md) | Version history |
| [`FutureIdeas/backlog.md`](FutureIdeas/backlog.md) | Post-1.0 backlog |

---

## Legal (hosted)

GitHub Pages from `/docs` on branch `main`:

- [Privacy](https://jacobrozell.github.io/PokeStopBuddy/privacy.html)
- [Support](https://jacobrozell.github.io/PokeStopBuddy/support.html)
- [Accessibility](https://jacobrozell.github.io/PokeStopBuddy/accessibility.html)
