# Waypoint Writer

An iOS app to quickly draft, generate, and fine-tune **Wayspot / Niantic Wayfarer
submission** content — titles, descriptions, and supporting statements — and iterate
on them until they're submission-ready.

> Product behavior lives in [`specs/`](specs/). This README is the build/run entry
> point only. For what ships today see [`docs/feature-inventory.md`](docs/feature-inventory.md).

## Requirements

- macOS with Xcode 15+ (iOS 17 SDK)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)
- [SwiftLint](https://github.com/realm/SwiftLint) (`brew install swiftlint`)

## Build & run

```bash
# 1. Generate the Xcode project from project.yml (the .xcodeproj is NOT committed)
xcodegen generate

# 2. Open and run, or build from CLI:
xcodebuild build \
  -scheme WaypointWriterCI \
  -destination 'platform=iOS Simulator,name=iPhone 15'

# 3. Run the fast PR test suite (unit + accessibility)
xcodebuild test \
  -scheme WaypointWriterCI \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

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

## Owner decisions (v1.0)

| Decision | Value |
|----------|-------|
| Bundle ID | `com.jacobrozell.waypointwriter` |
| Min iOS | 17.0 |
| Content generation | Offline template engine (LLM swappable behind `ContentGenerating`) |
| Bundled locales | `en` only (parity files kept in repo for CI) |
| Telemetry | Off in v1.0 |
| Tip/donate link | Hidden (`AppLinks.tipJar == nil`) |

See [`docs/agent-build-checklist.md`](docs/agent-build-checklist.md) for the full
build process and the reusable agent prompt library.
