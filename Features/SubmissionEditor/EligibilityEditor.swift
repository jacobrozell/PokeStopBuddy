import SwiftUI

/// Multi-select of eligibility criteria. Selection conveyed by checkmark + text.
struct EligibilityEditor: View {
    @Binding var selection: Set<EligibilityCriterion>

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                Text(L10n.string("editor.eligibility"))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                GuideInfoButton(topic: .eligibility)
            }
            ForEach(EligibilityCriterion.allCases) { criterion in
                Button {
                    toggle(criterion)
                } label: {
                    HStack {
                        Image(systemName: selection.contains(criterion) ? "checkmark.circle.fill" : "circle")
                        Text(criterion.displayName)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .frame(minHeight: Theme.minTouchTarget)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text(criterion.displayName))
                .accessibilityHint(Text(L10n.string("editor.eligibility.toggleHint")))
                .accessibilityAddTraits(selection.contains(criterion) ? .isSelected : [])
            }
        }
    }

    private func toggle(_ criterion: EligibilityCriterion) {
        if selection.contains(criterion) {
            selection.remove(criterion)
        } else {
            selection.insert(criterion)
        }
    }
}
