# Accessibility (release gate)

Target: **WCAG 2.1 AA**. No launch with open critical failures on core flows.

## Requirements

- VoiceOver: every interactive control has a label; meaningful hints; logical focus
  order; state changes announced.
- Touch targets ≥ 44×44 pt; primary actions larger.
- Dynamic Type: semantic text styles; key screens usable at AXXXL without clipping or
  horizontal scrolling.
- Contrast ≥ 4.5:1 body / 3:1 large text, light and dark. Evidence in
  `accessibility/` tracker.
- Non-color cues: quality score and status use icon + text, not color alone.
- Reduce Motion: gate decorative animation on `accessibilityReduceMotion`.
- Decorative images hidden from VoiceOver.
- Supported orientations: portrait + landscape, phone + iPad.

## Per-screen tracker

| Screen | VoiceOver | Dynamic Type | Contrast | Orientation | Status |
|--------|-----------|--------------|----------|-------------|--------|
| Submission Library (list) | planned | planned | planned | planned | building |
| Submission Editor | planned | planned | planned | planned | building |
| Quality Coach panel | planned | planned | planned | planned | building |
| Settings | planned | planned | planned | planned | building |

Manual audits land dated in `accessibility/audits/`.

## Verification
- Target release: v1.0
- Last verified: 2026-06-16
- Commit: (initial scaffold)
- Primary code paths: DesignSystem/, Tests/Accessibility/
