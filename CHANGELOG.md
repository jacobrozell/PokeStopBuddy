# Changelog

All notable changes to PokeStop Buddy. Format loosely follows
[Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Added
- Repo & agent infrastructure: XcodeGen project, SwiftLint (Domain-no-SwiftUI rule),
  pre-commit secret guard, Cursor rules, CI + nightly UI workflows.
- Spec system: governance, system specs, feature specs (each with a Verification block),
  feature inventory, brainstorm, FutureIdeas backlog.
- Design system tokens + accessible components (PrimaryButton, ScoreBadge, EmptyState).
- Domain (test-first): deterministic `TemplateContentGenerator` and heuristic
  `SubmissionQualityEvaluator` behind protocols; full model layer.
- Persistence: `SubmissionRepository` protocol, in-memory double, SwiftData `SchemaV1`.
- Core journey: Submission Editor (capture → generate → iterate → save) with live
  Quality coach and version history; Submission Library (list/detail/delete).
- Adaptive layout: iPad `NavigationSplitView` and a two-column editor; idiom-aware
  predicates (handles the iPhone Pro Max landscape case) with unit + landscape UI tests.
- Settings & preferences: appearance (system/light/dark) and new-submission defaults,
  persisted via `AppPreferences`; copy-all and ShareLink for submission content.
- Localization (`en`) with a parity/drift test; legal HTML for GitHub Pages.

### Notes
- v1.0 ships lean: photo guidance, LLM enhance, and export are gated behind
  `ReleaseSurface` until later slices.
