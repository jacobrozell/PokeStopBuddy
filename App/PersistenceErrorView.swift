import SwiftUI

/// Shown when persistence fails to bootstrap (fail-fast policy). Offers a reset path.
struct PersistenceErrorView: View {
    let message: String
    @State private var didReset = false

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Image(systemName: "externaldrive.badge.exclamationmark")
                .font(.system(size: 56))
                .foregroundStyle(Theme.Colors.critical)
                .accessibilityHidden(true)
            Text("Couldn't open your data")
                .font(.title2.weight(.semibold))
            Text(didReset
                 ? "Local data was reset. Please relaunch PokeStop Buddy."
                 : "Something went wrong opening local storage.")
                .font(.body)
                .foregroundStyle(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)

            if !didReset {
                PrimaryButton("Reset local data", systemImage: "trash",
                              identifier: "persistenceError.resetButton") {
                    resetStore()
                }
                .padding(.horizontal, Theme.Spacing.xl)
            }
        }
        .padding(Theme.Spacing.xl)
        .onAppear { AppLog.data.error("Persistence error surface shown: \(message)") }
    }

    private func resetStore() {
        // Best-effort reset: an in-memory container always succeeds, then clears the
        // on-disk store on next launch via the standard bootstrap path.
        if let container = try? PersistenceContainerFactory.makeContainer() {
            let repo = SwiftDataSubmissionRepository(container: container)
            try? repo.deleteAll()
        }
        didReset = true
    }
}

#Preview {
    PersistenceErrorView(message: "Sample error")
}
