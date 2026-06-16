import SwiftUI

/// Multi-select of eligibility criteria. Selection conveyed by checkmark + text.
struct EligibilityEditor: View {
    @Binding var selection: Set<EligibilityCriterion>

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text(L10n.string("editor.eligibility"))
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.Colors.textSecondary)
            ForEach(EligibilityCriterion.allCases) { criterion in
                Button {
                    toggle(criterion)
                } label: {
                    HStack {
                        Image(systemName: selection.contains(criterion) ? "checkmark.circle.fill" : "circle")
                        Text(criterion.displayName)
                        Spacer()
                    }
                    .frame(minHeight: Theme.minTouchTarget)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
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
