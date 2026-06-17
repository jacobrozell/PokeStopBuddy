import XCTest
@testable import PokeStopBuddy

final class OnboardingStoreTests: XCTestCase {
    private let suiteName = "com.pokestopbuddy.tests.onboarding"
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: suiteName)
        defaults.removePersistentDomain(forName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        super.tearDown()
    }

    func testShouldPresentOnLaunch_whenNeverCompleted() {
        let store = OnboardingStore(userDefaults: defaults, isEnabled: true)
        XCTAssertTrue(store.shouldPresentOnLaunch)
    }

    func testShouldNotPresent_afterMarkCompleted() {
        let store = OnboardingStore(userDefaults: defaults, isEnabled: true)
        store.markCompleted()
        XCTAssertFalse(store.shouldPresentOnLaunch)
    }

    func testShouldNotPresent_whenDisabled() {
        let store = OnboardingStore(userDefaults: defaults, isEnabled: false)
        XCTAssertFalse(store.shouldPresentOnLaunch)
    }

    func testClearPersistedState_resetsCompletion() {
        let store = OnboardingStore(userDefaults: defaults, isEnabled: true)
        store.markCompleted()
        store.clearPersistedState()
        XCTAssertTrue(store.shouldPresentOnLaunch)
    }
}
