import SwiftUI

/// Root navigation. The library adapts between a single navigation stack (iPhone) and a
/// sidebar + detail split (iPad). Layout context is resolved once here and injected into
/// the environment.
struct RootView: View {
    let dependencies: AppDependencies

    var body: some View {
        SubmissionLibraryView(dependencies: dependencies)
            .resolveLayoutContext()
            .preferredColorScheme(dependencies.preferences.appearance.colorScheme)
    }
}

#Preview {
    RootView(dependencies: .preview())
}
