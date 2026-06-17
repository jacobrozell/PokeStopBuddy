import SwiftUI

/// Brief confirmation banner for actions that don't navigate away (e.g. save on iPad split view).
struct SavedBanner: View {
    let message: String

    var body: some View {
        Label(message, systemImage: "checkmark.circle.fill")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(Theme.Colors.success)
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.sm)
            .background(.ultraThinMaterial, in: Capsule())
            .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
            .accessibilityAddTraits(.isStaticText)
    }
}
