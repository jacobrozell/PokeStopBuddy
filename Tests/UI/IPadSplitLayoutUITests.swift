import XCTest

/// iPad split-view smoke: sidebar list + detail editor, create → generate → save.
/// Run on the `PokeStopBuddy iPad` simulator (iPad Air 11-inch).
final class IPadSplitLayoutUITests: XCTestCase {
    private enum ID {
        static let libraryRoot = "submissionLibrary.root"
        static let editorRoot = "submissionEditor.root"
        static let detailPlaceholder = "submissionLibrary.detailPlaceholder"
        static let addButton = "submissionLibrary.addButton"
        static let placeNameField = "submissionEditor.placeNameField"
        static let generateButton = "submissionEditor.generateButton"
        static let titleField = "submissionEditor.titleField"
        static let saveButton = "submissionEditor.saveButton"
    }

    override func setUp() {
        continueAfterFailure = false
    }

    func testSplitViewCreateGenerateSave() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-uitest-reset", "-disable-telemetry", "-skip_onboarding"]
        app.launch()

        try skipUnlessPadFormFactor(app)

        XCTAssertTrue(UITestHelpers.waitForLibrary(app))

        app.buttons[ID.addButton].tap()

        let nameField = app.textFields[ID.placeNameField]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText("Town Square Fountain")
        UITestHelpers.dismissKeyboardIfPresent(in: app)

        let generate = UITestHelpers.waitForGenerateButton(app)
        generate.tap()

        XCTAssertTrue(
            app.textViews[ID.titleField].waitForExistence(timeout: 5)
                || app.textFields[ID.titleField].waitForExistence(timeout: 1)
        )

        app.buttons[ID.saveButton].tap()

        XCTAssertTrue(app.buttons[ID.saveButton].waitForExistence(timeout: 5))
        XCTAssertTrue(app.otherElements[ID.editorRoot].waitForExistence(timeout: 2))
        XCTAssertFalse(app.otherElements[ID.detailPlaceholder].exists)
        XCTAssertTrue(app.otherElements[ID.libraryRoot].exists)
    }
}

private func skipUnlessPadFormFactor(_ app: XCUIApplication) throws {
    guard app.windows.firstMatch.frame.width >= 500 else {
        throw XCTSkip("Run IPadSplitLayoutUITests on the PokeStopBuddy iPad simulator.")
    }
}
