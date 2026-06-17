# Feature: Submission Editor (core vertical slice)

The primary journey: capture inputs → generate → review/iterate → save.

## Flow

```
New / open submission
  → enter inputs (name, category, features, eligibility, location, style)
  → Generate  (ContentGenerating → GeneratedContent, appended to versions)
  → review generated title/description/supporting (editable)
  → Quality Coach panel updates live (QualityEvaluating)
  → fine-tune: tweak inputs & regenerate, or edit text directly, or revert a version
  → Save  (persist via SubmissionRepository)
```

## ViewModel: `SubmissionEditorViewModel` (`@Observable`)

- Holds editable `inputs` and current `content`.
- `generate()` — runs the generator, appends version, refreshes quality.
- `save()` — upserts via repository; maps errors to localized messages.
- `revert(to:)` — restores a prior `GeneratedContent` version.
- `copyAll()` — pasteboard string for quick submission elsewhere.
- Publishes `quality: QualityReport` recomputed on any change.

No business rules in the View. Generator + evaluator injected (default = template +
heuristic).

## Accessibility

- Each input labeled; `Generate`/`Save` are ≥44pt with identifiers
  `submissionEditor.generateButton` / `submissionEditor.saveButton`.
- In landscape, the editor uses side-by-side columns with pinned column headers on
  phones and wide layouts. **At accessibility text sizes (AXXXL+), the editor stacks
  into a single scrolling column** so fields are not clipped side-by-side.
- **Generate** also appears in the nav toolbar on phone landscape so it stays one tap
  away above the keyboard; iPad wide landscape uses the form button only.
- Quality score changes are announced to VoiceOver; generate/save/copy post announcements.
- Save and Generate are disabled until a place name is entered; Copy/Share disabled until
  content exists. An empty-state hint appears in the generated section before the first
  generation.
- **New drafts** focus the place name field on appear (skipped when VoiceOver is running).
- **iPad split:** brief **Saved** banner after save (no navigation away from detail).
- **Quality Coach:** tapping an issue scrolls to and focuses the related field when mappable.
- Severity conveyed by symbol + text.

## Verification
- Target release: v1.0
- Last verified: 2026-06-17
- Commit: (save banner, quality tap-to-focus, gated actions)
- Primary code paths: Features/SubmissionEditor/, Tests/Unit/SubmissionEditorViewModelTests.swift, Tests/Unit/EditorScrollTargetTests.swift, Tests/UI/SubmissionJourneyUITests.swift, Tests/UI/LandscapeLayoutUITests.swift
