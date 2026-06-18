import XCTest

/// Smoke test for the core journey: create → generate → save. Uses launch args to reset
/// the store so the run is deterministic.
///
/// Identifiers are inlined (UI tests run out-of-process and can't import the app module).
/// Keep these in sync with `Support/AccessibilityIDs.swift`.
final class SubmissionJourneyUITests: XCTestCase {
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

    func testCreateGenerateSaveJourney() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-uitest-reset", "-disable-telemetry", "-skip_onboarding"]
        app.launch()

        try skipUnlessPhoneFormFactor(app)

        XCTAssertTrue(UITestHelpers.waitForLibrary(app))

        app.buttons[ID.addButton].tap()

        let nameField = app.textFields[ID.placeNameField]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText("Riverside Community Mural")
        UITestHelpers.dismissKeyboardIfPresent(in: app)

        let generate = UITestHelpers.waitForGenerateButton(app)
        generate.tap()

        // Generated title should be present (TextField or TextView depending on size).
        XCTAssertTrue(
            app.textViews[ID.titleField].exists || app.textFields[ID.titleField].exists
        )

        app.buttons[ID.saveButton].tap()

        XCTAssertTrue(app.otherElements[ID.libraryRoot].waitForExistence(timeout: 5))
    }
}

private func skipUnlessPhoneFormFactor(_ app: XCUIApplication) throws {
    guard app.windows.firstMatch.frame.width < 500 else {
        throw XCTSkip("Run SubmissionJourneyUITests on the WaypointWriter iPhone simulator.")
    }
}
