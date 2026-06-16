# Feature flags & release surface

One module answers "is feature X reachable in this build?" — `Support/ReleaseSurface.swift`.
No scattered `#if` in views.

## v1.0 surface

| Area | Reachable in Release | Notes |
|------|----------------------|-------|
| Submission Editor (create/generate/iterate) | ✅ | core journey |
| Submission Library (list/detail) | ✅ | |
| Quality Coach | ✅ | |
| Settings + external links | ✅ | |
| Photo composition guidance | ❌ gated | planned v1.1 |
| LLM "enhance" generation | ❌ gated | planned v1.x |
| Export / share pack | ❌ gated | planned v1.2 |

`-enable_full_product_surface` launch arg reveals gated areas for dogfood/CI only —
never in App Store builds.

## Verification
- Target release: v1.0
- Last verified: 2026-06-16
- Commit: (initial scaffold)
- Primary code paths: Support/ReleaseSurface.swift, Support/FeatureFlags.swift
