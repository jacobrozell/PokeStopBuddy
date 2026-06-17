import SwiftUI

/// Category picker with guide help and typical eligibility pillars for the selection.
struct CategoryPickerRow: View {
    @Binding var selection: WayspotCategory
    @Binding var presentedGuideTopic: GuideTopic?

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack(alignment: .center, spacing: Theme.Spacing.xs) {
                Text(L10n.string("editor.category"))
                    .foregroundStyle(Theme.Colors.textPrimary)
                Spacer(minLength: Theme.Spacing.sm)
                GuideInfoButton(topic: .categories, presentedGuideTopic: $presentedGuideTopic)
            }

            Picker(L10n.string("editor.category"), selection: $selection) {
                ForEach(WayspotCategory.allCases) { category in
                    Text(category.displayName).tag(category)
                }
            }
            .accessibilityIdentifier(AccessibilityIDs.Editor.categoryPicker)

            CategoryPillarHint(category: selection)
        }
    }
}

/// Shows which eligibility pillars commonly apply to a Wayspot category.
struct CategoryPillarHint: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    let category: WayspotCategory

    private var reference: GuideCategoryReference? {
        GuideCategoryReference.all.first { $0.category == category }
    }

    var body: some View {
        if let reference {
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(L10n.string("editor.category.typicalPillars"))
                    .font(.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)

                if dynamicTypeSize.isAccessibilitySize {
                    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                        pillarChips(reference: reference)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text(pillarSummary(reference)))
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        pillarChips(reference: reference)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text(pillarSummary(reference)))
                }
            }
        }
    }

    private func pillarChips(reference: GuideCategoryReference) -> some View {
        HStack(spacing: Theme.Spacing.xs) {
            ForEach(reference.pillars) { pillar in
                TagChip(pillar.displayName, systemImage: "checkmark.seal")
            }
        }
    }

    private func pillarSummary(_ reference: GuideCategoryReference) -> String {
        let names = reference.pillars.map(\.displayName).joined(separator: ", ")
        return L10n.string("editor.category.pillarSummary", names)
    }
}
