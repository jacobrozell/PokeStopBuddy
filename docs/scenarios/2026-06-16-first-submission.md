# Scenario: First-time user drafts their first submission

**Date:** 2026-06-16
**Automated by:** `Tests/UI/SubmissionJourneyUITests.testCreateGenerateSaveJourney`

- **Persona:** First-time user, no saved submissions, standard text size.
- **Preconditions:** Fresh install (UI test launches with `-uitest-reset`).

## Steps

1. Launch the app → land on the **Submissions** library showing the empty state.
2. Tap **+** (`submissionLibrary.addButton`) → the editor opens.
3. Type a place name ("Riverside Community Mural") in `submissionEditor.placeNameField`.
4. Pick a category and writing style; add a key feature; select an eligibility criterion.
5. Tap **Generate content** (`submissionEditor.generateButton`).
6. Observe a title, description, and supporting statement appear; the **Quality coach**
   shows a score and any remaining issues.
7. Tap **Save** (`submissionEditor.saveButton`).
8. Return to the library → the new submission appears as a row with a score badge.

## Expected outcome

- Generated text is non-empty and within field limits.
- Submission persists and is visible in the library after returning.
- Quality score reflects the inputs (blockers gone once title/description/eligibility set).

## Failure modes to watch

- Generate enabled with an empty place name (should be disabled).
- Save without generating (allowed — saves an empty draft; quality flags blockers).
- Score not refreshing after manual edits to the generated fields.
- Version history not appended on repeated generation.
