# WCAG 2.1 AA tracker

Engineering status per screen. Manual on-device verification (VoiceOver, large text,
contrast, orientation) is required before claiming compliance — see `audits/`.

Legend: ✅ implemented in code · 🟡 partial · 🔜 needs device verification

| Screen | Labels/IDs | Dynamic Type | Non-color cues | 44pt targets | Orientation | Device-verified |
|--------|-----------|--------------|----------------|--------------|-------------|-----------------|
| Submission Library | ✅ | ✅ stacks rows at AXXXL | ✅ score badge icon+text | ✅ | 🟡 stack+split, UI smoke | 🔜 |
| Submission Editor | ✅ | ✅ stacks columns at AXXXL | ✅ severity icon+text | ✅ generate/save/feature/eligibility | 🟡 narrow+wide, landscape smoke | 🔜 |
| Quality coach panel | ✅ score announced | ✅ | ✅ | n/a | 🔜 | 🔜 |
| Settings | ✅ | ✅ | ✅ | ✅ rows | 🔜 | 🔜 |
| Persistence recovery | ✅ | ✅ | ✅ | ✅ reset | 🔜 | 🔜 |
| Submission Guide | ✅ | ✅ semantic styles | ✅ callout kind+icon | ✅ hub/info/category rows | 🟡 hub+detail | 🔜 |

## Evidence to collect (Phase 11)

- Contrast samples (light + dark) for accent on surface, body text, score colors.
- AXXXL screenshots of editor + library (no clipping / horizontal scroll).
- Orientation matrix: portrait/landscape × iPhone/iPad on editor + library.
- VoiceOver focus-order recordings for the create→generate→save journey.

No launch with open **critical** failures on the core journey.
