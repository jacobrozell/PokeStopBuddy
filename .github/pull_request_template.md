## Summary

<!-- What does this change and why? Link the spec/feature it implements. -->

## Checklist

- [ ] Spec updated (Verification block) if behavior changed — `specs/`
- [ ] Tests added/updated (unit for domain & ViewModels; UI smoke if a journey changed)
- [ ] `docs/feature-inventory.md` reflects reality
- [ ] New user-facing strings added to every bundled locale (`Resources/*.lproj`)
- [ ] Accessibility: labels/identifiers, 44pt targets, non-color cues
- [ ] Release surface unchanged, or gated via `Support/ReleaseSurface.swift`
- [ ] `xcodegen generate` + `WaypointWriterCI` scheme green locally (if on macOS)

## Notes for reviewers

<!-- Screenshots, trade-offs, anything risky. -->
