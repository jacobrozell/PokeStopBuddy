import Foundation

/// Persists first-run onboarding completion (Dart Buddy pattern).
struct OnboardingStore: Sendable {
    static let completedKey = "onboarding.completed"
    static let skipLaunchArgument = "-skip_onboarding"
    static let uiTestOnboardingLaunchArgument = "-ui_test_onboarding"

    let userDefaults: UserDefaults
    let isEnabled: Bool

    init(
        userDefaults: UserDefaults = .standard,
        isEnabled: Bool = OnboardingStore.defaultIsEnabled
    ) {
        self.userDefaults = userDefaults
        self.isEnabled = isEnabled
    }

    static var defaultIsEnabled: Bool {
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains(uiTestOnboardingLaunchArgument) {
            return true
        }
        return !arguments.contains(skipLaunchArgument) && !arguments.contains("-uitest-reset")
    }

    var shouldPresentOnLaunch: Bool {
        isEnabled && !userDefaults.bool(forKey: Self.completedKey)
    }

    func markCompleted() {
        userDefaults.set(true, forKey: Self.completedKey)
    }

    func clearPersistedState() {
        userDefaults.removeObject(forKey: Self.completedKey)
    }
}

enum OnboardingPresentationMode: Sendable {
    case firstLaunch
    case replay
}
