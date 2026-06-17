# Accessibility audit: Core journey (library → editor → guide)

**Date:** 2026-06-17  
**Scope:** Submission library (search, delete confirm, empty states), submission editor (quality tap-to-focus, save banner, gated actions), guide assets  
**Method:** Code review + contract/unit tests; simulator UI tree smoke; on-device VoiceOver still required

## Summary

Core journey screens now include search/filter, delete confirmation, iPad save feedback without navigation, quality-issue navigation to fields, bundled guide placeholder assets (replace with GO captures), guide sheet on library, and new-draft place-name focus (skipped when VoiceOver is on). **Full device VoiceOver verification remains open** before claiming WCAG AA compliance.

## Findings addressed in code

| Area | Fix |
|------|-----|
| Library search | `.searchable` on iPhone stack and iPad split; empty-search row |
| Delete | Confirmation dialog before destructive delete; selection cleared |
| iPad save | `SavedBanner` overlay when save does not change column |
| Quality panel | Issue rows tappable; hint + scroll/focus to related field |
| Editor AXXXL | Stacks wide columns via `effectiveEditorUsesWideLayout` |
| Guide visuals | Bundled placeholder PNGs + `GuideSchematicScreenshot` fallback |
| Guide presentation | `GuideLibrarySheet` on iPhone and iPad library toolbar |
| New draft | Place name field focused on appear (not when VoiceOver running) |
| Empty states | Revised copy for first draft and iPad detail placeholder |

## Contract / unit tests

- `Tests/Accessibility/CoreJourneyAccessibilityContractTests.swift`
- `Tests/Unit/LocalizationParityTests.swift` — new UI keys
- `Tests/Unit/SubmissionLibraryViewModelTests.swift` — search filter
- `Tests/Unit/EditorScrollTargetTests.swift` — quality field mapping
- `Tests/Unit/GuideCatalogTests.swift` — schematic localization keys
- `Tests/Unit/GuideAssetCatalogTests.swift` — bundled process screenshots
- `Tests/UI/SubmissionGuideUITests.swift` — sheet navigation + autofocus smoke

## Simulator smoke (partial)

Automated UI tests verify guide sheet open/dismiss on iPad, hub navigation, and keyboard
focus on new draft. This is **not** a substitute for VoiceOver.

## Device verification checklist (🔜)

- [ ] VoiceOver: library search → filter → clear → row opens editor
- [ ] VoiceOver: swipe delete → confirm/cancel dialog
- [ ] VoiceOver: quality issue double-tap → focus moves to field
- [ ] VoiceOver: iPad save → banner announced or readable
- [ ] VoiceOver: guide sheet → topic → Done dismisses
- [ ] Dynamic Type AXXXL: library rows stack; editor single column
- [ ] Light + dark: saved banner, guide images, search empty row

## Confidence

**Medium** — engineering controls and automated smoke are in place; manual VoiceOver audit required for release gate.
