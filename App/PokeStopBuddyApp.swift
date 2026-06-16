import SwiftUI

@main
struct PokeStopBuddyApp: App {
    private let bootstrap = AppDependencies.bootstrap()

    var body: some Scene {
        WindowGroup {
            switch bootstrap {
            case .success(let dependencies):
                RootView(dependencies: dependencies)
            case .failure(let message):
                PersistenceErrorView(message: message)
            }
        }
    }
}
