# Future ideas backlog (non-authoritative)

Promote an item to `specs/features/` only when its rules are locked.

## v1.1 polish follow-through

Items from the content + polish pass. Engineering scaffolding is in place; track
remaining manual or gated work here.

| Item | Status | Notes |
|------|--------|-------|
| Real Pokémon GO guide screenshots | 🔜 manual | Replace placeholder PNGs in `Resources/Assets.xcassets/guide.process.*` per `docs/guide-screenshot-checklist.md` |
| On-device VoiceOver audit (core journey) | 🔜 manual | Checklist in `accessibility/audits/2026-06-17-core-journey.md` |
| Guide screenshot pinch-to-zoom | 🔜 v1.2 | Spec non-goal for v1.1; static images only |
| Guide dark-mode screenshot variants | 🔜 manual | When GO UI differs materially; see checklist |

## New capabilities

| Idea | Sketch | Likely release |
|------|--------|----------------|
| Photo composition guidance | overlay tips, distance/angle, no faces/plates | v1.1 |
| LLM enhance | optional Claude-backed `ContentGenerating` behind flag + key | v1.x |
| Export / share pack | copy-all + formatted card image | v1.2 |
| Map + location capture | CoreLocation, candidate pins | v1.x |
| iCloud sync | SwiftData + CloudKit | v2.0 |
| Widgets / App Intents | "New draft", "Last submission status" | v1.4 |
| Category templates library | community-tuned phrasing per `WayspotCategory` | v1.3 |
| Reviewer practice mode | criteria training quizzes | v2.0 |

## Shipped (reference)

| Idea | Spec |
|------|------|
| Submission guide (in-app) | `specs/features/submission-guide.md` — sheet + placeholder assets; real GO captures pending |
| Settings guide sheet | Same `GuideLibrarySheet` as library toolbar |
| Editor info topic sheets | `GuideTopicSheet` at editor root; UI-tested |
