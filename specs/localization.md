# Localization

- All user-facing strings go through `String(localized:)` via the `L10n` accessor.
  No hard-coded UI strings.
- Base locale `en` is the source of truth.
- New key → added to every bundled locale file in the same PR; a parity test checks
  key count + format specifiers.
- **Lean ship (v1.0):** bundle `en` only. Keep additional `.lproj` files in the repo
  for CI parity as locales are added.

## Verification
- Target release: v1.0
- Last verified: 2026-06-16
- Commit: (initial scaffold)
- Primary code paths: Resources/en.lproj/Localizable.strings, Support/L10n.swift
