import SwiftUI

/// Shown when persistence fails to bootstrap (fail-fast policy). Offers a reset path.
struct PersistenceErrorView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    let message: String
    @State private var didReset = false

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Image(systemName: "externaldrive.badge.exclamationmark")
                .font(.system(size: iconSize, weight: .medium))
                .foregroundStyle(Theme.Colors.critical)
                .symbolRenderingMode(.hierarchical)
                .padding(Theme.Spacing.lg)
                .background(Theme.Colors.critical.opacity(0.12), in: Circle())
                .accessibilityHidden(true)

            VStack(spacing: Theme.Spacing.sm) {
                Text(L10n.string("persistence.error.title"))
                    .font(.title2.weight(.semibold))
                Text(didReset
                     ? L10n.string("persistence.error.resetDone")
                     : L10n.string("persistence.error.message"))
                    .font(.body)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            if !didReset {
                PrimaryButton(
                    L10n.string("persistence.error.resetButton"),
                    systemImage: "trash",
                    identifier: "persistenceError.resetButton"
                ) {
                    resetStore()
                }
                .padding(.horizontal, Theme.Spacing.xl)
            }
        }
        .padding(Theme.Spacing.xl)
        .onAppear { AppLog.data.error("Persistence error surface shown: \(message)") }
    }

    private var iconSize: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 56 : 48
    }

    private func resetStore() {
        // Best-effort reset: an in-memory container always succeeds, then clears the
        // on-disk store on next launch via the standard bootstrap path.
        if let container = try? PersistenceContainerFactory.makeContainer() {
            let repo = SwiftDataSubmissionRepository(container: container)
            try? repo.deleteAll()
        }
        HapticFeedback.success()
        didReset = true
    }
}

#Preview {
    PersistenceErrorView(message: "Sample error")
}
