import SwiftUI

@main
struct PokeStopBuddyApp: App {
    private let bootstrap: Result<AppDependencies, AppDependencies.BootstrapError>

    init() {
        // Unit tests embed in the host app. Skip the live SwiftData bootstrap (which
        // touches Library/Application Support and can crash on a clean simulator) — the
        // suite uses an in-memory repository via AppDependencies.preview().
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            bootstrap = .success(AppDependencies.preview(seed: []))
        } else {
            bootstrap = AppDependencies.bootstrap()
        }
    }

    var body: some Scene {
        WindowGroup {
            switch bootstrap {
            case .success(let dependencies):
                RootView(dependencies: dependencies)
            case .failure(let error):
                PersistenceErrorView(message: error.message)
            }
        }
    }
}
