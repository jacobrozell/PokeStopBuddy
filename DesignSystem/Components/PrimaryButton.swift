import SwiftUI

/// Full-width primary action button with a guaranteed ≥44pt target and a11y identifier.
public struct PrimaryButton: View {
    private let title: String
    private let systemImage: String?
    private let identifier: String
    private let isEnabled: Bool
    private let action: () -> Void

    @ScaledMetric(relativeTo: .body) private var verticalPadding: CGFloat = 14

    public init(
        _ title: String,
        systemImage: String? = nil,
        identifier: String,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.identifier = identifier
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.sm) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title).fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, minHeight: Theme.minTouchTarget)
            .padding(.vertical, verticalPadding - 14)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(!isEnabled)
        .accessibilityIdentifier(identifier)
        .accessibilityLabel(Text(title))
    }
}
