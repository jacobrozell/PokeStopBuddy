# Feature: Launch splash & first-run onboarding

Branded cold start and a short first-run tour (Dart Buddy / MiniMuster pattern).

## Goals

- Static **launch screen** matches the in-app splash (dark navy + brand mark).
- **In-app splash** covers bootstrap; cross-fades to main shell (respects Reduce Motion).
- **Onboarding** on first launch: welcome → defaults → how it works → ready.
- Replay from Settings; skip from welcome jumps to ready.
- Persist completion in `UserDefaults`; `-skip_onboarding` for UI tests.

## Non-goals

- Wayfarer account linking or Niantic quiz content (see Submission Guide).
- Marketing paywalls or account creation.
- Telemetry events in v1.0 (facade off).

## Brand assets

| Asset | Role |
|-------|------|
| `AppIcon` | Dark-navy hex waypoint mark (v2 dark cyan dot) |
| `LaunchBackground` | Solid dark navy (`#0A1628` light/dark) |
| `BrandMarkView` | SwiftUI vector mark for splash + onboarding (not a stretched bitmap) |

## Launch flow

```
UILaunchScreen (solid LaunchBackground only — no UIImage; avoids full-screen stretch)
        ↓
WaypointWriterApp bootstrap (async task, min ~500ms hold when motion on)
        ↓
LaunchSplashView (mark + wordmark + loading dots) → cross-fade
        ↓
RootView → SubmissionLibraryView
        ↓ (first launch)
OnboardingFlowView (fullScreenCover, non-dismissible)
```

Splash accessibility: combined element, label `launch.loading`, id `launch.splash`.

## Onboarding steps

| Step | Progress | Content | Primary action |
|------|----------|---------|----------------|
| Welcome | — | Brand mark, value prop | Continue / Skip |
| Defaults | 1/3 | Appearance, default style & category | Continue |
| How it works | 2/3 | Draft → Generate → Copy to Wayfarer | Continue |
| Ready | 3/3 | Summary | Get started |

Skip on welcome: jumps to **Ready** (still shows back). Completing Ready calls
`OnboardingStore.markCompleted()`.

Replay mode (`Settings`): same flow, dismissible, does not rewrite completion unless
user finishes Ready again.

## Root gating

`RootView` presents onboarding when `OnboardingStore.shouldPresentOnLaunch`.
Settings row **View onboarding** presents replay mode.

## Accessibility identifiers

See `AccessibilityIDs.Onboarding` and `AccessibilityIDs.Launch`.

## Verification
- Target release: v1.1
- Last verified: 2026-06-17
- Commit: (onboarding-and-launch)
- Primary code paths: App/WaypointWriterApp.swift, App/RootView.swift, DesignSystem/Components/LaunchSplashView.swift, Features/Onboarding/, Support/Onboarding/OnboardingStore.swift, Features/Settings/SettingsView.swift, Tests/Unit/OnboardingStoreTests.swift
