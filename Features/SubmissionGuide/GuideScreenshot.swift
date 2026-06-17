import SwiftUI

/// Pokémon GO screenshot with caption; shows a placeholder when the asset is not bundled yet.
struct GuideScreenshot: View {
    let reference: GuideScreenshotRef

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Group {
                if UIImage(named: reference.assetName) != nil {
                    Image(reference.assetName)
                        .resizable()
                        .scaledToFit()
                } else {
                    GuideSchematicScreenshot(assetName: reference.assetName)
                }
            }
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
            .overlay {
                RoundedRectangle(cornerRadius: Theme.Radius.md)
                    .strokeBorder(Theme.Colors.textSecondary.opacity(0.2))
            }

            Text(L10n.string(reference.captionKey))
                .font(.caption)
                .foregroundStyle(Theme.Colors.textSecondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(L10n.string(reference.accessibilityKey)))
    }
}
