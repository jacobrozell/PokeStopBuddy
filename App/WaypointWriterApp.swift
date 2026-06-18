import SwiftUI

@main
struct WaypointWriterApp: App {
    @State private var bootstrapResult: Result<AppDependencies, BootstrapError>?
    @State private var showsLaunchSplash: Bool

    init() {
        let flags = FeatureFlags.fromProcess()
        let isUITestLaunch = flags.resetStore
        let isUnitTestHost = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil

        _showsLaunchSplash = State(initialValue: !isUITestLaunch && !isUnitTestHost)

        if isUnitTestHost {
            // Unit tests embed in the host app. Skip live SwiftData bootstrap — the suite
            // uses an in-memory repository via AppDependencies.preview().
            _bootstrapResult = State(initialValue: .success(AppDependencies.preview(seed: [])))
        } else if isUITestLaunch {
            _bootstrapResult = State(initialValue: AppDependencies.bootstrap(flags: flags))
        }
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if let bootstrapResult {
                    bootstrapContent(bootstrapResult)
                        .opacity(showsLaunchSplash ? 0 : 1)
                }

                if showsLaunchSplash {
                    LaunchSplashView()
                }
            }
            .task {
                guard bootstrapResult == nil else { return }
                await runBootstrap()
            }
        }
    }

    @ViewBuilder
    private func bootstrapContent(_ result: Result<AppDependencies, BootstrapError>) -> some View {
        switch result {
        case .success(let dependencies):
            RootView(dependencies: dependencies)
        case .failure(let error):
            PersistenceErrorView(message: error.localizedDescription)
        }
    }

    @MainActor
    private func runBootstrap() async {
        if shouldHoldLaunchSplashForMotion, showsLaunchSplash {
            try? await Task.sleep(for: .milliseconds(500))
        }
        bootstrapResult = AppDependencies.bootstrap()
        guard bootstrapResult != nil else { return }
        if UIAccessibility.isReduceMotionEnabled {
            showsLaunchSplash = false
        } else {
            withAnimation(.easeInOut(duration: 0.3)) {
                showsLaunchSplash = false
            }
        }
    }

    private var shouldHoldLaunchSplashForMotion: Bool {
        guard !UIAccessibility.isReduceMotionEnabled else { return false }
        return !ProcessInfo.processInfo.arguments.contains("-uitest-reset")
    }
}
