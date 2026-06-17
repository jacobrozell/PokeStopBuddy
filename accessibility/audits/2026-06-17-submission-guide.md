# Accessibility audit: Submission Guide

**Date:** 2026-06-17  
**Scope:** Guide hub, topic detail, category reference grid, editor category help  
**Method:** Code review + contract tests; on-device VoiceOver pass still required

## Summary

Guide screens now ship with explicit labels, hints, identifiers, non-color callout semantics,
and reduce-motion support on category expand/collapse. **Device verification remains open**
before claiming WCAG AA compliance.

## Findings addressed in code

| Area | Fix |
|------|-----|
| Hub cards | Combined title + summary label; navigation hint |
| Category grid rows | Spoken pillar summary; expanded state includes examples; ≥44pt row |
| Callout cards | Kind spoken (tip/do/don't) plus title and body — not color alone |
| Info buttons | Hint explains sheet behavior; 44pt target |
| Editor category | Info opens Categories topic; inline typical-pillar chips |
| Bullets | Decorative bullets hidden; text combined for VoiceOver |
| Motion | Category expand respects Reduce Motion |

## Contract tests

- `Tests/Accessibility/GuideAccessibilityContractTests.swift`

## Device verification checklist (🔜)

- [ ] VoiceOver: hub → process topic → back; focus order logical
- [ ] VoiceOver: editor category (?) → categories sheet → Done
- [ ] VoiceOver: category grid expand/collapse announces pillars + examples
- [ ] Dynamic Type AXXXL: guide detail readable without horizontal scroll
- [ ] Light + dark contrast on callout cards and hub cards

## Confidence

**Medium** — engineering controls are in place; manual audit required for release gate.
