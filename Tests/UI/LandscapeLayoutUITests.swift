import XCTest

/// Orientation regression smoke: the core journey must remain usable in landscape.
/// On iPad this exercises the split + two-column editor; on a large phone, the
/// two-column editor. Identifiers mirror `Support/AccessibilityIDs.swift`.
final class LandscapeLayoutUITests: XCTestCase {
    private enum ID {
        static let libraryRoot = "submissionLibrary.root"
        static let addButton = "submissionLibrary.addButton"
        static let placeNameField = "submissionEditor.placeNameField"
        static let generateButton = "submissionEditor.generateButton"
        static let titleField = "submissionEditor.titleField"
        static let saveButton = "submissionEditor.saveButton"
    }

    override func setUp() {
        continueAfterFailure = false
    }

    override func tearDown() {
        XCUIDevice.shared.orientation = .portrait
    }

    func testCreateInLandscape() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-uitest-reset", "-disable-telemetry", "-skip_onboarding"]
        app.launch()

        try skipUnlessPhoneFormFactor(app)

        XCUIDevice.shared.orientation = .landscapeLeft

        XCTAssertTrue(UITestHelpers.waitForLibrary(app))

        app.buttons[ID.addButton].tap()

        let nameField = app.textFields[ID.placeNameField]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText("Oakwood Trailhead")
        UITestHelpers.dismissKeyboardIfPresent(in: app)

        let generate = UITestHelpers.waitForGenerateButton(app)
        generate.tap()

        XCTAssertTrue(
            app.textViews[ID.titleField].waitForExistence(timeout: 5)
                || app.textFields[ID.titleField].waitForExistence(timeout: 1)
        )
        XCTAssertTrue(app.buttons[ID.saveButton].isHittable)
        app.buttons[ID.saveButton].tap()

        XCTAssertTrue(app.otherElements[ID.libraryRoot].waitForExistence(timeout: 5))
    }
}

// MARK: - Device guard

private func skipUnlessPhoneFormFactor(_ app: XCUIApplication) throws {
    // iPhone portrait width is below ~430pt; iPad simulators are much wider.
    guard app.windows.firstMatch.frame.width < 500 else {
        throw XCTSkip("Run LandscapeLayoutUITests on the WaypointWriter iPhone simulator.")
    }
}
