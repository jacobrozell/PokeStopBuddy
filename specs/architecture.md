# Architecture

## Layers & dependency rule

```
Features (SwiftUI + @Observable MVVM)
   │ depends on
   ▼
Domain (pure logic)  ◄── Data (repository protocols + DTO mapping)
   ▲                            │ implemented by
   │                            ▼
   └──────────────────  Persistence (SwiftData container, schema, migrations)
```

- Dependencies point **inward**. Domain has zero framework dependencies (no SwiftUI,
  no SwiftData). Enforced by SwiftLint custom rule `domain_no_swiftui`.
- Features reference `any SubmissionRepository` and `ContentGenerating`, resolved
  from `AppDependencies` (composition root) at launch.

## Module map

| Module | Key types |
|--------|-----------|
| `Domain/Models` | `Submission`, `SubmissionInputs`, `GeneratedContent`, `WayspotCategory`, `EligibilityCriterion`, `SubmissionStatus` |
| `Domain/Generation` | `ContentGenerating`, `TemplateContentGenerator`, `GenerationStyle` |
| `Domain/Quality` | `QualityEvaluating`, `SubmissionQualityEvaluator`, `QualityReport`, `QualityIssue` |
| `Data` | `SubmissionRepository` (protocol), `InMemorySubmissionRepository`, `SwiftDataSubmissionRepository` |
| `Persistence` | `SubmissionEntity`, `SchemaV1`, `PersistenceContainerFactory` |
| `Features/SubmissionLibrary` | list + detail of saved submissions |
| `Features/SubmissionEditor` | the core create/generate/iterate journey |
| `Features/Settings` | preferences + external links |
| `App` | `WaypointWriterApp`, `AppDependencies`, `RootView` |
| `Support` | `AppLinks`, `ReleaseSurface`, `FeatureFlags`, `AccessibilityIDs`, `AppLog` |
| `DesignSystem` | `Theme`, color/space/type tokens, reusable components |

## Command pattern

User actions on a submission (`create`, `regenerate`, `revertToVersion`, `archive`)
are expressed as intent methods on the ViewModel that call Domain use cases — keeping
logic reusable for future widgets / App Intents.

## Verification
- Target release: v1.0
- Last verified: 2026-06-16
- Commit: (initial scaffold)
- Primary code paths: App/AppDependencies.swift, Domain/, Data/, Persistence/
