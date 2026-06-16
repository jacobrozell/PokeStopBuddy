# Tech stack

| Concern | Choice | Notes |
|---------|--------|-------|
| Language | Swift 5.9, strict concurrency | |
| Min OS | iOS 17.0 | enables SwiftData + `@Observable` |
| UI | SwiftUI | |
| State | `@Observable` ViewModels | Observation framework |
| Persistence | SwiftData | behind `SubmissionRepository` protocol |
| Project gen | XcodeGen (`project.yml`) | `.xcodeproj` not committed |
| Lint | SwiftLint | custom rule bans SwiftUI in Domain |
| Content engine | Offline `TemplateContentGenerator` | LLM swappable behind `ContentGenerating` |
| Telemetry | none in v1.0 | facade reserved in `Support/AppLog.swift` |
| Third-party SDKs | none in v1.0 | |

## Devices

- iPhone + iPad (`TARGETED_DEVICE_FAMILY = 1,2`).
- Orientations: portrait + landscape (left/right).
