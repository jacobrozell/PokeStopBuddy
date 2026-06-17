import SwiftUI

/// Root navigation. The library adapts between a single navigation stack (iPhone) and a
/// sidebar + detail split (iPad). Layout context is resolved once here and injected into
/// the environment.
struct RootView: View {
    let dependencies: AppDependencies

    @State private var showsOnboarding = false
    private let onboardingStore = OnboardingStore()

    var body: some View {
        SubmissionLibraryView(dependencies: dependencies)
            .resolveLayoutContext()
            .preferredColorScheme(dependencies.preferences.appearance.colorScheme)
            .onAppear {
                presentOnboardingIfNeeded()
            }
            .fullScreenCover(isPresented: $showsOnboarding) {
                OnboardingFlowView(
                    mode: .firstLaunch,
                    dependencies: dependencies,
                    store: onboardingStore
                ) {
                    showsOnboarding = false
                }
            }
    }

    private func presentOnboardingIfNeeded() {
        guard onboardingStore.shouldPresentOnLaunch, !showsOnboarding else { return }
        showsOnboarding = true
    }
}

#Preview {
    RootView(dependencies: .preview())
}
