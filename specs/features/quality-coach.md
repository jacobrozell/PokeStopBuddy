# Feature: Quality Coach

Scores a submission against Wayfarer-style quality heuristics and lists concrete,
actionable issues so the user can fine-tune before submitting.

## Contract (`QualityEvaluating`)

```swift
protocol QualityEvaluating {
    func evaluate(_ submission: Submission) -> QualityReport
}
```

`QualityReport`:
- `score: Int` (0–100)
- `issues: [QualityIssue]` — each has `severity` (`.blocker`, `.warning`, `.tip`),
  `field`, and a localized `message`.
- `isSubmittable: Bool` — true when no `.blocker` issues remain.

## Heuristics (`SubmissionQualityEvaluator`, v1.0)

| Check | Severity | Rule |
|-------|----------|------|
| Title present | blocker | non-empty after trim |
| Title length | warning | 3–100 chars; warn if very short |
| Generic title | warning | flags words like "sign", "pole", "bench" alone |
| Description present | blocker | non-empty |
| Description length | warning | ≥ 20 chars and ≤ 250 |
| Eligibility selected | blocker | at least one criterion |
| Supporting statement present | warning | non-empty |
| Supporting mentions location/access | tip | encourage "how to find it" |
| Sensitive location | warning | flags school/private-residence keywords |

Scoring: start at 100, subtract weighted penalties per issue (blocker 35, warning 12,
tip 4), clamp to 0–100. Non-color presentation: each severity has an SF Symbol + text.

## Verification
- Target release: v1.0
- Last verified: 2026-06-16
- Commit: (initial scaffold)
- Primary code paths: Domain/Quality/SubmissionQualityEvaluator.swift, Tests/Unit/SubmissionQualityEvaluatorTests.swift
