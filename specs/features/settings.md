# Feature: Settings & Preferences

Preferences that outlive a single session, plus external links and destructive actions.

## Preferences (`AppPreferences`)

Observable, `UserDefaults`-backed model (inject a custom suite for tests).

| Preference | Values | Default | Effect |
|------------|--------|---------|--------|
| `appearance` | system / light / dark | system | `RootView.preferredColorScheme` |
| `defaultStyle` | concise / descriptive / formal | descriptive | seeds new submissions |
| `defaultCategory` | `WayspotCategory` | publicArt | seeds new submissions |

New submissions inherit `defaultStyle` / `defaultCategory`; existing submissions keep
their own values (verified by `AppPreferencesTests`).

## Screen

Settings is presented as a sheet from the library on both idioms. Sections:
appearance, new-submission defaults, reference (Wayfarer guidelines), support & legal
(privacy / support / accessibility; tip jar only when `AppLinks.tipJar != nil`), and a
destructive **Delete all submissions** with confirmation.

## Accessibility

Pickers carry identifiers (`settings.appearancePicker`, `settings.defaultStylePicker`,
`settings.defaultCategoryPicker`); delete is `role: .destructive` behind a confirmation
dialog.

## Verification
- Target release: v1.0
- Last verified: 2026-06-16
- Commit: (preferences)
- Primary code paths: Support/AppPreferences.swift, Support/AppearanceMode.swift, Features/Settings/SettingsView.swift, Tests/Unit/AppPreferencesTests.swift
