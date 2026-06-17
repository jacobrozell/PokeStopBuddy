import XCTest

/// Smoke tests for the submission guide hub and process topic.
final class SubmissionGuideUITests: XCTestCase {
    private enum ID {
        static let libraryRoot = "submissionLibrary.root"
        static let guideOpen = "guide.openButton"
        static let processHub = "guide.hub.process"
        static let processDetail = "guide.detail.process"
    }

    override func setUp() {
        continueAfterFailure = false
    }

    func testOpenGuideFromLibrary() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-uitest-reset", "-disable-telemetry", "-skip_onboarding"]
        app.launch()

        try skipUnlessPhoneFormFactor(app)

        XCTAssertTrue(UITestHelpers.waitForLibrary(app))

        UITestHelpers.button(app, id: ID.guideOpen).tap()

        XCTAssertTrue(UITestHelpers.waitForGuideRoot(app))

        let processHub = UITestHelpers.button(app, id: ID.processHub)
        XCTAssertTrue(processHub.waitForExistence(timeout: 10))
        processHub.tap()

        XCTAssertTrue(UITestHelpers.waitForGuideDetail(app, topic: "process", navigationTitle: "Nomination process"))
    }

    func testOpenGuideFromLibraryOnIPad() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-uitest-reset", "-disable-telemetry", "-skip_onboarding"]
        app.launch()

        try skipUnlessPadFormFactor(app)

        XCTAssertTrue(UITestHelpers.waitForLibrary(app))

        UITestHelpers.button(app, id: ID.guideOpen).tap()

        XCTAssertTrue(UITestHelpers.waitForGuideRoot(app))

        let done = UITestHelpers.button(app, id: "guide.doneButton")
        XCTAssertTrue(done.waitForExistence(timeout: 5))
        done.tap()

        XCTAssertTrue(app.otherElements[ID.libraryRoot].waitForExistence(timeout: 5))
    }

    func testCategoriesTopicFromGuideHub() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-uitest-reset", "-disable-telemetry", "-skip_onboarding"]
        app.launch()

        try skipUnlessPhoneFormFactor(app)

        XCTAssertTrue(UITestHelpers.waitForLibrary(app))

        UITestHelpers.button(app, id: ID.guideOpen).tap()
        XCTAssertTrue(UITestHelpers.waitForGuideRoot(app))

        let categoriesHub = UITestHelpers.button(app, id: "guide.hub.categories")
        XCTAssertTrue(categoriesHub.waitForExistence(timeout: 10))
        categoriesHub.tap()

        XCTAssertTrue(
            UITestHelpers.waitForGuideDetail(
                app,
                topic: "categories",
                navigationTitle: "Categories & tags"
            )
        )
    }

    func testEditorCategoryInfoOpensCategoriesTopic() throws {
        let app = XCUIApplication()
        app.launchArguments = [
            "-uitest-reset", "-disable-telemetry", "-skip_onboarding", "-uitest-disable-autofocus"
        ]
        app.launch()

        try skipUnlessPhoneFormFactor(app)

        XCTAssertTrue(UITestHelpers.waitForLibrary(app))
        UITestHelpers.button(app, id: "submissionLibrary.addButton").tap()
        XCTAssertTrue(app.textFields["submissionEditor.placeNameField"].waitForExistence(timeout: 5))

        let infoButton = app.buttons["guide.info.categories"]
        XCTAssertTrue(infoButton.waitForExistence(timeout: 5))
        infoButton.tap()

        XCTAssertTrue(
            UITestHelpers.waitForGuideDetail(
                app,
                topic: "categories",
                navigationTitle: "Categories & tags"
            )
        )
        XCTAssertTrue(UITestHelpers.button(app, id: "guide.doneButton").waitForExistence(timeout: 5))
    }

    func testSettingsGuideOpensSheet() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-uitest-reset", "-disable-telemetry", "-skip_onboarding"]
        app.launch()

        try skipUnlessPhoneFormFactor(app)

        XCTAssertTrue(UITestHelpers.waitForLibrary(app))

        let settingsButton = app.buttons["settings.openButton"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()

        XCTAssertTrue(
            app.navigationBars["Settings"].waitForExistence(timeout: 10)
                || app.sheets.navigationBars["Settings"].waitForExistence(timeout: 10)
        )

        let guideLink = app.sheets.buttons["settings.guideLink"]
        if guideLink.waitForExistence(timeout: 3) {
            guideLink.tap()
        } else {
            app.buttons["settings.guideLink"].tap()
        }
        XCTAssertTrue(UITestHelpers.waitForGuideRoot(app))

        UITestHelpers.button(app, id: "guide.doneButton").tap()
        XCTAssertTrue(UITestHelpers.waitForLibrary(app))
    }

    func testNewDraftAutofocusesPlaceName() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-uitest-reset", "-disable-telemetry", "-skip_onboarding"]
        app.launch()

        try skipUnlessPhoneFormFactor(app)

        XCTAssertTrue(UITestHelpers.waitForLibrary(app))

        UITestHelpers.button(app, id: "submissionLibrary.addButton").tap()

        let placeName = app.textFields["submissionEditor.placeNameField"]
        XCTAssertTrue(placeName.waitForExistence(timeout: 5))
        XCTAssertTrue(app.keyboards.element(boundBy: 0).waitForExistence(timeout: 3))
    }
}

private func skipUnlessPhoneFormFactor(_ app: XCUIApplication) throws {
    guard app.windows.firstMatch.frame.width < 500 else {
        throw XCTSkip("Run phone guide tests on the PokeStopBuddy iPhone simulator.")
    }
}

private func skipUnlessPadFormFactor(_ app: XCUIApplication) throws {
    guard app.windows.firstMatch.frame.width >= 500 else {
        throw XCTSkip("Run iPad guide tests on the PokeStopBuddy iPad simulator.")
    }
}
