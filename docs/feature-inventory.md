# Feature inventory

What exists in the build **today**. (Behavior contract lives in `specs/`.)

Legend: ✅ shipped · 🟡 partial · 🔜 planned · 🧪 stub

| Feature | Status | Notes |
|---------|--------|-------|
| Domain: content generation (template engine) | ✅ | `TemplateContentGenerator`, deterministic, unit-tested |
| Domain: quality evaluation | ✅ | `SubmissionQualityEvaluator`, unit-tested |
| Domain: submission model + versions | ✅ | iteration history |
| Data: in-memory repository | ✅ | used by tests + previews |
| Data: SwiftData repository | ✅ | `SchemaV1` |
| Submission Editor (create/generate/iterate/save) | ✅ | core vertical slice |
| Submission Library (list/detail/delete) | ✅ | |
| Quality Coach panel | ✅ | live scoring in editor |
| Settings + external links | ✅ | privacy/support/accessibility; tip jar hidden |
| Preferences (appearance + new-submission defaults) | ✅ | `AppPreferences`, persisted, unit-tested |
| Design system tokens + components | ✅ | |
| Adaptive layout (iPad split + two-column editor) | ✅ | pure `LayoutContext`, unit + landscape UI tests |
| Localization (`en`) | ✅ | `L10n` wrapper + parity/drift test |
| Copy-all / ShareLink for submission content | ✅ | quick hand-off into Wayfarer |
| Photo composition guidance | 🔜 | gated, v1.1 |
| LLM "enhance" generation | 🔜 | gated, behind `ContentGenerating` |
| Export / share pack | 🔜 | gated, v1.2 |
| Telemetry | 🔜 | facade only, off in v1.0 |

## Build status vs ship status

This scaffold targets a **buildable Phase 0–6 foundation**. The Xcode project is
generated from `project.yml` (run `xcodegen generate`); CI/macOS is required to
compile and run the simulator-based tests.
