# WCAG 2.1 AA tracker

Engineering status per screen. Manual on-device verification (VoiceOver, large text,
contrast, orientation) is required before claiming compliance — see `audits/`.

Legend: ✅ implemented in code · 🟡 partial · 🔜 needs device verification

| Screen | Labels/IDs | Dynamic Type | Non-color cues | 44pt targets | Orientation | Device-verified |
|--------|-----------|--------------|----------------|--------------|-------------|-----------------|
| Submission Library | ✅ | ✅ semantic styles | ✅ score badge icon+text | ✅ | 🔜 | 🔜 |
| Submission Editor | ✅ | ✅ | ✅ severity icon+text | ✅ generate/save/feature/eligibility | 🔜 | 🔜 |
| Quality coach panel | ✅ | ✅ | ✅ | n/a | 🔜 | 🔜 |
| Settings | ✅ | ✅ | ✅ | ✅ rows | 🔜 | 🔜 |
| Persistence recovery | ✅ | ✅ | ✅ | ✅ reset | 🔜 | 🔜 |

## Evidence to collect (Phase 11)

- Contrast samples (light + dark) for accent on surface, body text, score colors.
- AXXXL screenshots of editor + library (no clipping / horizontal scroll).
- Orientation matrix: portrait/landscape × iPhone/iPad on editor + library.
- VoiceOver focus-order recordings for the create→generate→save journey.

No launch with open **critical** failures on the core journey.
