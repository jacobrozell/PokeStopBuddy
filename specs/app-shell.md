# App shell & adaptive layout

## Information architecture

Single primary surface — the **Submission Library** — with the **Editor** as the
detail/secondary surface and **Settings** as a sheet. No tab bar in v1.0 (lean IA).

```
RootView (.resolveLayoutContext)
└── SubmissionLibraryView
     ├── iPhone  → NavigationStack (list → push Editor)
     └── iPad    → NavigationSplitView (sidebar list | detail Editor)
     └── Settings (sheet, both idioms)
```

## Adaptive layout (Phase 7)

Decisions are made by the pure `LayoutContext` type in
`DesignSystem/Layout/AdaptiveLayout.swift` and unit-tested in `AdaptiveLayoutTests`.

| Predicate | Rule | Rationale |
|-----------|------|-----------|
| `usesSplitNavigation` | `idiom == .pad && horizontal == .regular` | Sidebar+detail only on a **true iPad**. Excludes iPhone Pro Max landscape, which reports `.regular` width but is not an iPad. |
| `editorUsesWideLayout` | `horizontal == .regular` | Two-column editor (inputs \| generated + coach) whenever width allows — iPad any orientation, large phone landscape. Width-driven by intent. |
| `isLandscape` | `vertical == .compact` | Landscape detection per HIG. |

**Key rule (7.4):** distinguish phone vs iPad with the **idiom**, not horizontal size
class alone. The `usesSplitNavigation` test suite asserts the Pro Max landscape case
explicitly.

## Orientations

Portrait + landscape on iPhone and iPad (`Info.plist`, see `specs/accessibility.md`).
The core journey (create → generate → save) is covered by a portrait UI smoke
(`SubmissionJourneyUITests`) and a landscape smoke (`LandscapeLayoutUITests`).

## Verification
- Target release: v1.0
- Last verified: 2026-06-16
- Commit: (adaptive layout)
- Primary code paths: App/RootView.swift, Features/SubmissionLibrary/SubmissionLibraryView.swift, Features/SubmissionEditor/SubmissionEditorView.swift, DesignSystem/Layout/AdaptiveLayout.swift
