# Release checklist — PokeStop Buddy

Scoped to **what v1.0 actually exposes** (see `specs/feature-flags.md`).

## Pre-tag gate (~10 min)

- [ ] `xcodegen generate` clean
- [ ] `PokeStopBuddyCI` scheme: unit + accessibility green
- [ ] `PokeStopBuddy` scheme: UI smoke (`SubmissionJourneyUITests`) green
- [ ] SwiftLint clean (no errors)
- [ ] Release-surface audit: gated features (photo guidance, LLM enhance, export) not reachable without `-enable_full_product_surface`
- [ ] No hard-coded user strings (all via `L10n` / `Localizable.strings`)

## Device matrix (manual — requires hardware/sim)

| Check | iPhone | iPad |
|-------|--------|------|
| Create → generate → save journey | [ ] | [ ] |
| VoiceOver pass on editor + library | [ ] | [ ] |
| Dynamic Type AXXXL no clipping | [ ] | [ ] |
| Portrait + landscape | [ ] | [ ] |
| Light + dark contrast | [ ] | [ ] |
| Persistence survives relaunch | [ ] | [ ] |
| Delete-all confirmation works | [ ] | [ ] |

## Owner decisions (close before submit)

- [ ] Tip/donate link — keep hidden (`AppLinks.tipJar == nil`) or set URL
- [ ] Locales — `en` only in bundle (confirmed)
- [ ] Telemetry — off in Release (confirmed)
- [ ] Bundle ID `com.pokestopbuddy.app` — new listing vs update

## Store / legal

- [ ] GitHub Pages serving `docs/*.html`
- [ ] Privacy + Support URLs set in App Store Connect
- [ ] Screenshots show only shipped, ungated features
- [ ] Subtitle/keywords claim only shipped features
- [ ] App is not affiliated-with disclaimer present in listing

## Post-submit

- [ ] Monitor crashes / reviews
- [ ] Watch for Wayfarer policy changes that affect generated phrasing
