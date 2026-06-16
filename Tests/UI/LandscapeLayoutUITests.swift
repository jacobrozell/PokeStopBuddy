import XCTest

/// Orientation regression smoke: the core journey must remain usable in landscape.
/// On iPad this exercises the split + two-column editor; on a large phone, the
/// two-column editor. Identifiers mirror `Support/AccessibilityIDs.swift`.
final class LandscapeLayoutUITests: XCTestCase {
    private enum ID {
        static let addButton = "submissionLibrary.addButton"
        static let placeNameField = "submissionEditor.placeNameField"
        static let generateButton = "submissionEditor.generateButton"
        static let saveButton = "submissionEditor.saveButton"
    }

    override func setUp() {
        continueAfterFailure = false
    }

    override func tearDown() {
        XCUIDevice.shared.orientation = .portrait
    }

    func testCreateInLandscape() {
        let app = XCUIApplication()
        app.launchArguments = ["-uitest-reset", "-disable-telemetry"]
        app.launch()

        XCUIDevice.shared.orientation = .landscapeLeft

        app.buttons[ID.addButton].tap()

        let nameField = app.textFields[ID.placeNameField]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText("Oakwood Trailhead")

        app.buttons[ID.generateButton].tap()
        XCTAssertTrue(app.buttons[ID.saveButton].isHittable)
        app.buttons[ID.saveButton].tap()
    }
}
