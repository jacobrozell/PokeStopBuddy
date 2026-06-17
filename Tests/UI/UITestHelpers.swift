import XCTest

enum UITestHelpers {
    /// Dismisses the software keyboard so form actions below the fold are reachable.
    static func dismissKeyboardIfPresent(in app: XCUIApplication) {
        guard app.keyboards.count > 0 else { return }
        let keyboard = app.keyboards.element(boundBy: 0)
        if keyboard.buttons["Return"].exists {
            keyboard.buttons["Return"].tap()
        } else if keyboard.buttons["Done"].exists {
            keyboard.buttons["Done"].tap()
        } else {
            app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1)).tap()
        }
        let deadline = Date().addingTimeInterval(2)
        while Date() < deadline, app.keyboards.count > 0 {
            RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        }
    }

    static func waitForGenerateButton(_ app: XCUIApplication, timeout: TimeInterval = 10) -> XCUIElement {
        let generate = app.buttons["submissionEditor.generateButton"]
        if generate.waitForExistence(timeout: timeout) { return generate }
        for _ in 0..<4 where !generate.exists {
            app.swipeUp()
        }
        XCTAssertTrue(generate.waitForExistence(timeout: 2))
        return generate
    }

    /// Waits until bootstrap finishes and the library shell is interactive.
    @discardableResult
    static func waitForLibrary(_ app: XCUIApplication, timeout: TimeInterval = 10) -> Bool {
        app.otherElements["submissionLibrary.root"].waitForExistence(timeout: timeout)
    }

    /// Finds a button in the app hierarchy, including nested sheets.
    static func button(_ app: XCUIApplication, id: String) -> XCUIElement {
        if app.buttons[id].exists { return app.buttons[id] }
        for index in 0..<app.sheets.count {
            let sheet = app.sheets.element(boundBy: index)
            if sheet.buttons[id].exists { return sheet.buttons[id] }
            if sheet.otherElements[id].exists { return sheet.otherElements[id] }
        }
        if app.otherElements[id].exists { return app.otherElements[id] }
        return app.buttons[id]
    }

    /// Finds a control by accessibility identifier anywhere in the hierarchy.
    static func control(_ app: XCUIApplication, id: String) -> XCUIElement {
        let match = app.descendants(matching: .any).matching(identifier: id).firstMatch
        if match.exists { return match }
        return button(app, id: id)
    }

    /// Finds a container in the app hierarchy, including nested sheets.
    static func container(_ app: XCUIApplication, id: String) -> XCUIElement {
        if app.otherElements[id].exists { return app.otherElements[id] }
        for index in 0..<app.sheets.count {
            let candidate = app.sheets.element(boundBy: index).otherElements[id]
            if candidate.exists { return candidate }
        }
        return app.otherElements[id]
    }

    /// Waits for the guide hub inside a sheet or pushed navigation stack.
    @discardableResult
    static func waitForGuideRoot(_ app: XCUIApplication, timeout: TimeInterval = 10) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if container(app, id: "guide.root").exists { return true }
            if app.navigationBars["Submission guide"].exists { return true }
            for index in 0..<app.sheets.count {
                let sheet = app.sheets.element(boundBy: index)
                if sheet.navigationBars["Submission guide"].exists { return true }
            }
            RunLoop.current.run(until: Date().addingTimeInterval(0.15))
        }
        return false
    }

    /// Waits for a guide topic detail screen (sheet or push).
    @discardableResult
    static func waitForGuideDetail(
        _ app: XCUIApplication,
        topic: String,
        navigationTitle: String? = nil,
        timeout: TimeInterval = 10
    ) -> Bool {
        let detailID = "guide.detail.\(topic)"
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if container(app, id: detailID).exists { return true }
            if let navigationTitle {
                if app.navigationBars[navigationTitle].exists { return true }
                for index in 0..<app.sheets.count {
                    let sheet = app.sheets.element(boundBy: index)
                    if sheet.navigationBars[navigationTitle].exists { return true }
                }
            }
            RunLoop.current.run(until: Date().addingTimeInterval(0.15))
        }
        return false
    }
}
