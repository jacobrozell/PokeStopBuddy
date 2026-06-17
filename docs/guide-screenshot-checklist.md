# Guide screenshot checklist

Use when capturing Pokémon GO nomination screenshots for `Resources/Assets.xcassets/` (guide.process.* imagesets).
Spec: `specs/features/submission-guide.md`.

## Before capture

- [ ] Run `swift Scripts/generate_guide_assets.swift` only when refreshing **placeholder** PNGs.
- [ ] Use a personal account on a device you control.
- [ ] Pick a **public** landmark (park sign, public art, historical marker).
- [ ] Complete Wayfarer onboarding on the account.
- [ ] Note iOS version and Pokémon GO app version in the PR description.

## Capture list

| Asset ID | Screen | What to highlight |
|----------|--------|-------------------|
| `guide.process.menu` | Settings → Uploads | New PokéStop entry |
| `guide.process.map` | Pin placement | Pin on object |
| `guide.process.mainPhoto` | Main photo | Camera UI |
| `guide.process.supportingPhoto` | Supporting photo | Wider context shot |
| `guide.process.titleDescription` | Title & description | Both fields visible |
| `guide.process.category` | Category picker | Several tag options |
| `guide.process.preview` | Preview | Summary before submit |
| `guide.process.supporting` | Supporting info | Eligibility / additional info |
| `guide.process.upload` | Upload | Upload now / later |

Use **Upload Later** or abandon before final submit if you do not intend to nominate the
location.

## Redaction (required)

- [ ] Trainer name / buddy name
- [ ] Email address
- [ ] Precise home address or coordinates in map UI
- [ ] Other players' faces (prefer locations with no bystanders)

## Export

- [ ] PNG, sRGB
- [ ] @2x and @3x widths (e.g. 390 pt and 430 pt logical width exports)
- [ ] Dark mode variant if UI differs significantly

## Alt text

Add English alt text to `specs/features/submission-guide.md` asset table and
`guide.screenshot.<id>.a11y` localization key before merge.

## Legal

Educational use only. If Niantic objects, remove assets and ship text-only guide content.
