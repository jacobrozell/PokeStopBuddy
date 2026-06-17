# App shell & adaptive layout

## Information architecture

Single primary surface — the **Submission Library** — with the **Editor** as the
detail/secondary surface and **Settings** as a sheet. No tab bar in v1.0 (lean IA).

```
RootView (.resolveLayoutContext)
└── SubmissionLibraryView
     ├── iPhone  → NavigationStack (list → push Editor)
     └── iPad    → NavigationSplitView (sidebar list | detail Editor)
     ├── Submission Guide (push or sheet — v1.1, see submission-guide.md)
     └── Settings (sheet, both idioms)
```

**Cold start (v1.1):** `UILaunchScreen` (dark navy + brand mark) → in-app
`LaunchSplashView` during bootstrap → cross-fade to library. First launch presents
`OnboardingFlowView` as a full-screen cover (see `onboarding-and-launch.md`).

On iPad, the sidebar uses `.sidebar` list style with a fixed column width (280–400 pt).
`activeDetailID` drives the detail column so the editor survives sidebar list rebuilds
after the first save. Saving selects the row in the sidebar and keeps the editor in
the detail column (there is no push/pop dismiss). The first submission is auto-selected
when the list loads.

## Adaptive layout (Phase 7)

Decisions are made by the pure `LayoutContext` type in
`DesignSystem/Layout/AdaptiveLayout.swift` and unit-tested in `AdaptiveLayoutTests`.

| Predicate | Rule | Rationale |
|-----------|------|-----------|
| `usesSplitNavigation` | `idiom == .pad && horizontal == .regular` | Sidebar+detail only on a **true iPad**. Excludes iPhone Pro Max landscape, which reports `.regular` width but is not an iPad. |
| `editorUsesWideLayout` | `horizontal == .regular \|\| (idiom == .phone && isLandscape)` | Two-column editor whenever width is regular **or** a phone is landscape. Standard iPhones report compact width in landscape but have scarce vertical space — splitting inputs from output keeps Generate and the coach reachable. |
| `editorShowsToolbarGenerate` | `isLandscape && (idiom == .phone \|\| !editorUsesWideLayout)` | Toolbar Generate on phone landscape (reachability) and iPad slide-over; hidden on iPad wide landscape where the form button suffices. |
| `isLandscape` | `vertical == .compact` | Landscape detection per HIG. |

**Key rule (7.4):** distinguish phone vs iPad with the **idiom**, not horizontal size
class alone. The `usesSplitNavigation` test suite asserts the Pro Max landscape case
explicitly.

## Orientations

Portrait + landscape on iPhone and iPad (`Info.plist`, see `specs/accessibility.md`).
The core journey (create → generate → save) is covered by a portrait UI smoke
(`SubmissionJourneyUITests` on iPhone), a landscape smoke (`LandscapeLayoutUITests` on
iPhone), and an iPad split smoke (`IPadSplitLayoutUITests` on `PokeStopBuddy iPad`).

## Verification
- Target release: v1.0
- Last verified: 2026-06-17
- Commit: (iPad split — save selection + `PokeStopBuddy iPad` simulator)
- Primary code paths: App/RootView.swift, Features/SubmissionLibrary/SubmissionLibraryView.swift, Features/SubmissionEditor/SubmissionEditorView.swift, DesignSystem/Layout/AdaptiveLayout.swift, Tests/UI/IPadSplitLayoutUITests.swift
