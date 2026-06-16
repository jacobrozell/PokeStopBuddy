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
- Quality result announced on change; severity conveyed by symbol + text.

## Verification
- Target release: v1.0
- Last verified: 2026-06-16
- Commit: (initial scaffold)
- Primary code paths: Features/SubmissionEditor/, Tests/Unit/SubmissionEditorViewModelTests.swift
