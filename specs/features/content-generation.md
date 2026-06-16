# Feature: Content Generation

Turn a few structured inputs about a candidate Wayspot into polished submission
content: a **title**, a **description**, and a **supporting statement**, that the user
can iterate and fine-tune.

## Background (Niantic Wayfarer)

A PokeStop / Wayspot nomination needs:
- **Title** — the name of the real-world place/object.
- **Description** — 1–2 sentences saying what it is.
- **Supporting statement** — why it's eligible + how a reviewer can verify/find it.

Eligibility = meets at least one criterion:
- `historicCultural` — historic, cultural, or educational significance.
- `exercise` — a great place to be physically active.
- `socialExploration` — a great place to be social / explore.

## Inputs (`SubmissionInputs`)

| Field | Required | Notes |
|-------|----------|-------|
| `placeName` | yes | raw name the user typed |
| `category` | yes | `WayspotCategory` |
| `keyFeatures` | 0..n | short bullets ("hand-painted", "1923", "open to public") |
| `eligibility` | 1..n | selected `EligibilityCriterion` set |
| `locationHint` | optional | where it is ("NE corner of Main & 1st") |
| `accessNotes` | optional | public access / pedestrian access |
| `style` | yes | `GenerationStyle` (see below) |

## Generation styles (`GenerationStyle`)

- `concise` — short, factual.
- `descriptive` — richer, more vivid wording.
- `formal` — neutral/official tone for reviewers.

## Engine contract (`ContentGenerating`)

```swift
protocol ContentGenerating {
    func generate(from inputs: SubmissionInputs) -> GeneratedContent
}
```

`TemplateContentGenerator` is the v1.0 deterministic implementation. An LLM-backed
generator can later conform to the same protocol behind a feature flag.

### Title rules

- Title-case the place name; trim whitespace; collapse repeated spaces.
- Strip leading articles only when they make the title generic (keep proper names).
- Never exceed `GenerationLimits.titleMax` (100 chars); truncate on a word boundary.

### Description rules

- One sentence template seeded by category + up to two key features.
- Style adjusts adjectives/connectives, not facts.
- Respect `GenerationLimits.descriptionMax` (250 chars).

### Supporting statement rules

- Sentence 1: eligibility rationale, composed from selected criteria phrasing.
- Sentence 2: location/access guidance from `locationHint` / `accessNotes` when present.
- Respect `GenerationLimits.supportingMax` (500 chars).

### Determinism

Same inputs → identical output (no randomness). This makes the engine unit-testable
and reproducible for "fine-tune" workflows.

## Iteration / fine-tune

- Each `generate` produces a `GeneratedContent`; the editor appends it to the
  submission's `versions` history.
- User can edit any field manually; manual edits are preserved as the "current"
  content and can also be snapshotted as a version.
- User can revert to a previous version.

## Verification
- Target release: v1.0
- Last verified: 2026-06-16
- Commit: (initial scaffold)
- Primary code paths: Domain/Generation/TemplateContentGenerator.swift, Tests/Unit/TemplateContentGeneratorTests.swift
