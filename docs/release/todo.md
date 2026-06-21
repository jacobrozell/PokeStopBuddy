# Waypoint Writer — release todo

Status legend: `[ ]` todo · `[x]` done

Expanded runbook: [`release_checklist.md`](release_checklist.md) · Listing: [`app-store-listing.md`](app-store-listing.md)

## Pre-tag gate

- [ ] **XcodeGen clean** — `xcodegen generate`
- [ ] **CI green** — `WaypointWriterCI` unit + accessibility; UI smoke on `WaypointWriter`
- [ ] **SwiftLint clean**
- [ ] **Release-surface audit** — gated photo/LLM/export need `-enable_full_product_surface`
- [ ] **L10n audit** — no hard-coded user strings

## Device matrix

- [ ] **Core journey** — create → generate → save on iPhone + iPad
- [ ] **VoiceOver** — editor + library
- [ ] **Dynamic Type AXXXL** — no clipping
- [ ] **Appearance** — portrait/landscape × light/dark
- [ ] **Persistence** — survives relaunch; delete-all confirmation

## Store / legal

- [ ] **GitHub Pages** — `docs/*.html` live
- [ ] **App Store Connect** — privacy + support URLs
- [ ] **Listing copy** — from `app-store-listing.md`; Wayfarer disclaimer present
- [ ] **TestFlight** — What to Test updated
- [ ] **Real GO guide screenshots** — replace placeholders ([`../../FutureIdeas/backlog.md`](../../FutureIdeas/backlog.md))
