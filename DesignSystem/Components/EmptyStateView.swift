import SwiftUI

/// Reusable empty state with a clear next action.
public struct EmptyStateView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private let systemImage: String
    private let title: String
    private let message: String
    private let identifier: String

    public init(systemImage: String, title: String, message: String, identifier: String) {
        self.systemImage = systemImage
        self.title = title
        self.message = message
        self.identifier = identifier
    }

    public var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Image(systemName: systemImage)
                .font(.system(size: iconSize, weight: .medium))
                .foregroundStyle(Theme.Colors.accent)
                .symbolRenderingMode(.hierarchical)
                .padding(Theme.Spacing.lg)
                .background(Theme.Colors.accent.opacity(0.12), in: Circle())
                .accessibilityHidden(true)

            VStack(spacing: Theme.Spacing.sm) {
                Text(title)
                    .font(.title3.weight(.semibold))
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(Theme.Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier(identifier)
    }

    private var iconSize: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 56 : 40
    }
}
