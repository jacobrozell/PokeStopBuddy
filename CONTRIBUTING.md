# Contributing to PokeStop Buddy

Read this before writing code. Agents: this is your style + architecture contract.

## Architecture: layered, one direction

```
Features (SwiftUI + MVVM)
        │  depends on
        ▼
Domain (pure logic)  ◄── Data (repository protocols)
        ▲                        │ implemented by
        │                        ▼
        └───────────────  Persistence (SwiftData)
```

**Hard rules**

1. **Domain never imports SwiftUI or SwiftData.** It is pure, deterministic Swift.
   Enforced by a SwiftLint custom rule.
2. Features depend on protocols (`any SubmissionRepository`, `ContentGenerating`),
   never on concrete persistence types.
3. No business rules in `View.body`. Logic lives in the ViewModel or Domain.
4. ViewModels map typed Domain errors → localized user messages.

## Spec-first

No user-visible behavior without an authoritative spec in `specs/`.
- Brainstorm/idea → `FutureIdeas/` (non-authoritative)
- Locked behavior → `specs/<Feature>Spec.md` with a **Verification** block
- What actually ships → `docs/feature-inventory.md`

Source-of-truth hierarchy:
`specs/governance.md` → system specs → feature specs → feature inventory → brainstorm.

## Test-first for domain

Pure logic and ViewModels get unit tests **before** UI polish. If something is hard
to unit test, it's probably in the wrong layer.

- `Tests/Unit/` — domain + ViewModel logic
- `Tests/Accessibility/` — token contrast, label/identifier contracts
- `Tests/UI/` — XCUITest, one smoke per journey (split by concern)

## Style

- SwiftLint must pass (`swiftlint`). Line length warning at 120.
- Swift 5.9, strict concurrency. Prefer `@Observable` ViewModels (iOS 17).
- Naming: `SomethingView`, `SomethingViewModel`, `SomethingRepository`.
- All reusable components ship with `accessibilityLabel`, `accessibilityHint` (where
  useful), and a stable `accessibilityIdentifier` for UI tests.

## UI test identifiers

Convention: `screen.element` lower camel, e.g. `submissionEditor.generateButton`,
`submissionList.addButton`. Centralize in `Support/AccessibilityIDs.swift`.

## Accessibility is a release gate

Target WCAG 2.1 AA: VoiceOver, 44pt targets, Dynamic Type, contrast, non-color cues,
Reduce Motion, supported orientations. No launch with open critical a11y failures on
core flows.

## Commits

Small, focused, descriptive. Update the relevant spec Verification block and the
checklist progress log when a phase completes.
