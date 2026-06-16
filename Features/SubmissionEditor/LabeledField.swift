import SwiftUI

/// A labeled, multi-line text field with a live character-limit counter.
struct LabeledField: View {
    let label: String
    @Binding var text: String
    let identifier: String
    let limit: Int

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            HStack {
                Text(label)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.Colors.textSecondary)
                Spacer()
                Text("\(text.count)/\(limit)")
                    .font(.caption2)
                    .monospacedDigit()
                    .foregroundStyle(text.count > limit ? Theme.Colors.critical : Theme.Colors.textSecondary)
                    .accessibilityHidden(true)
            }
            TextField(label, text: $text, axis: .vertical)
                .accessibilityIdentifier(identifier)
                .accessibilityLabel(Text(label))
        }
    }
}
