# Feature: Submission Library

List + detail of saved submissions — the surface that reads what the editor writes.

## Flow

- List of saved submissions, newest first, showing title, category, status, and a
  quality `ScoreBadge`.
- Empty state guides the user to create their first submission or open the guide.
- **Search** filters by title, place name, category, and status (case-insensitive).
- Tap → opens the Submission Editor for that submission.
- Swipe to delete → **confirmation dialog** before removal.

## ViewModel: `SubmissionLibraryViewModel` (`@Observable`)

- `load()` from `SubmissionRepository`.
- `delete(_:)` after user confirms in the view.
- `filteredSubmissions(matching:)` for search.
- Derives the per-row quality score via `QualityEvaluating` (cached).

## iPad split

- Sidebar list + detail column; `activeDetailID` keeps detail stable after save.
- Detail placeholder when nothing selected.

## Accessibility

- Each row is a single VoiceOver element summarizing "title, category, score N of 100,
  status".
- Add button: `submissionLibrary.addButton`, ≥44pt.
- Search field uses `library.search.prompt`; empty results use `library.search.empty`.

## Verification
- Target release: v1.0
- Last verified: 2026-06-17
- Commit: (library search + delete confirmation + copy polish)
- Primary code paths: Features/SubmissionLibrary/, Tests/Unit/SubmissionLibraryViewModelTests.swift
