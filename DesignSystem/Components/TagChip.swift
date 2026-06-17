import SwiftUI

/// Compact label for categories, pillars, or related topics.
public struct TagChip: View {
    private let title: String
    private let systemImage: String?

    public init(_ title: String, systemImage: String? = nil) {
        self.title = title
        self.systemImage = systemImage
    }

    public var body: some View {
        HStack(spacing: Theme.Spacing.xs) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.caption2)
            }
            Text(title)
                .font(.caption.weight(.medium))
        }
        .padding(.horizontal, Theme.Spacing.sm)
        .padding(.vertical, Theme.Spacing.xs)
        .background(Theme.Colors.surfaceSecondary, in: Capsule())
        .foregroundStyle(Theme.Colors.textPrimary)
    }
}
