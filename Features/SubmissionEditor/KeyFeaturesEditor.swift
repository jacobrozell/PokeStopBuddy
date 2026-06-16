import SwiftUI

/// Edits the list of short feature bullets that feed the generator.
struct KeyFeaturesEditor: View {
    @Binding var features: [String]
    @State private var newFeature = ""

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text(L10n.string("editor.keyFeatures"))
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.Colors.textSecondary)

            ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                HStack {
                    Text("• \(feature)")
                    Spacer()
                    Button {
                        features.remove(at: index)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundStyle(Theme.Colors.critical)
                    }
                    .frame(width: Theme.minTouchTarget, height: Theme.minTouchTarget)
                    .accessibilityLabel(Text(L10n.string("editor.removeFeature", feature)))
                }
            }

            HStack {
                TextField(L10n.string("editor.addFeature"), text: $newFeature)
                Button {
                    addFeature()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .frame(width: Theme.minTouchTarget, height: Theme.minTouchTarget)
                .disabled(newFeature.trimmingCharacters(in: .whitespaces).isEmpty)
                .accessibilityLabel(Text(L10n.string("editor.addFeature")))
            }
        }
    }

    private func addFeature() {
        let trimmed = newFeature.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        features.append(trimmed)
        newFeature = ""
    }
}
