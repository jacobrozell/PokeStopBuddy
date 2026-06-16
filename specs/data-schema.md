# Data schema & persistence

## Policy

- Versioned SwiftData schema: `SchemaV1`, `SchemaV2`, … Each migration is explicit
  and covered by a migration test (N−1 → N) in CI.
- Repositories expose Domain models; persistence entities never leak into Features.
- Container bootstrap failure policy (v1.0): **fail-fast** with a recovery screen
  (`PersistenceErrorView`) offering "Reset local data". Logged via `AppLog`.

## SchemaV1

### `SubmissionEntity`

| Field | Type | Notes |
|-------|------|-------|
| `id` | `UUID` | `@Attribute(.unique)` |
| `title` | `String` | working/display title |
| `placeName` | `String` | raw input |
| `categoryRaw` | `String` | `WayspotCategory.rawValue` |
| `keyFeatures` | `[String]` | input bullets |
| `locationHint` | `String` | how to find it |
| `accessNotes` | `String` | public access / safety notes |
| `eligibilityRaw` | `[String]` | selected `EligibilityCriterion` raw values |
| `styleRaw` | `String` | `GenerationStyle.rawValue` |
| `generatedTitle` | `String` | current generated title |
| `generatedDescription` | `String` | |
| `generatedSupporting` | `String` | |
| `versionsData` | `Data` | JSON-encoded `[GeneratedContent]` history |
| `statusRaw` | `String` | `SubmissionStatus.rawValue` |
| `createdAt` | `Date` | |
| `updatedAt` | `Date` | |

`versionsData` stores the iteration history so users can compare/revert generated
drafts. Encoded as JSON to keep the entity flat and migration-friendly.

## Verification
- Target release: v1.0
- Last verified: 2026-06-16
- Commit: (initial scaffold)
- Primary code paths: Persistence/Schema/SchemaV1.swift, Data/SwiftDataSubmissionRepository.swift
