# Feature: Submission Library

List + detail of saved submissions — the surface that reads what the editor writes.

## Flow

- List of saved submissions, newest first, showing title, category, status, and a
  quality `ScoreBadge`.
- Empty state guides the user to create their first submission.
- Tap → opens the Submission Editor for that submission.
- Swipe to archive/delete (confirmed for delete).

## ViewModel: `SubmissionLibraryViewModel` (`@Observable`)

- `load()` from `SubmissionRepository`.
- `delete(_:)` with confirmation.
- Derives the per-row quality score via `QualityEvaluating` (cached).

## Accessibility

- Each row is a single VoiceOver element summarizing "title, category, score N of 100,
  status".
- Add button: `submissionLibrary.addButton`, ≥44pt.

## Verification
- Target release: v1.0
- Last verified: 2026-06-16
- Commit: (initial scaffold)
- Primary code paths: Features/SubmissionLibrary/, Tests/Unit/SubmissionLibraryViewModelTests.swift
