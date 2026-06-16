import SwiftUI

/// Reusable empty state with a clear next action.
public struct EmptyStateView: View {
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
        VStack(spacing: Theme.Spacing.md) {
            Image(systemName: systemImage)
                .font(.system(size: 48))
                .foregroundStyle(Theme.Colors.textSecondary)
                .accessibilityHidden(true)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(Theme.Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier(identifier)
    }
}
