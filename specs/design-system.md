# Design system

Two token layers, kept separate:

- **Brand palette** — Waypoint Writer marketing colors (accent blue/teal).
- **Semantic / system surfaces** — map to system materials so light/dark + contrast
  settings are respected.

## Tokens (`DesignSystem/Theme.swift`)

| Token group | Examples |
|-------------|----------|
| Color (semantic) | `accent`, `surface`, `surfaceSecondary`, `textPrimary`, `textSecondary`, `success`, `warning`, `critical` |
| Spacing | `xs=4, sm=8, md=16, lg=24, xl=32` |
| Radius | `sm=8, md=12, lg=20` |
| Typography | semantic text styles only (`largeTitle`…`caption`) for Dynamic Type |

## Component rules

- Reusable components (`PrimaryButton`, `Card`, `TagChip`, `ScoreBadge`,
  `EmptyStateView`) ship with default `accessibilityLabel` / `accessibilityIdentifier`.
- `@ScaledMetric` for any fixed dimension that should scale with text.
- Quality status always pairs an SF Symbol + text label (non-color cue).

## Verification
- Target release: v1.0
- Last verified: 2026-06-16
- Commit: (initial scaffold)
- Primary code paths: DesignSystem/
