import XCTest

final class PhotoMVPVisualDemoUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testMockPhotoCaptureVisualFlow() throws {
        let app = XCUIApplication()
        app.launchArguments = [
            "--mock-glasses",
            "--mock-ai",
            "--disable-real-speech"
        ]
        app.launch()

        attachScreenshot(named: "01_app_launched", app: app)

        let title = app.staticTexts["appTitle"]
        XCTAssertTrue(title.waitForExistence(timeout: 10))

        let connectButton = app.buttons["connectButton"]
        XCTAssertTrue(connectButton.waitForExistence(timeout: 10))
        connectButton.tap()

        let status = app.staticTexts["connectionStatus"]
        XCTAssertTrue(status.waitForExistence(timeout: 10))
        XCTAssertTrue(status.label.contains("Mock Connected"))
        attachScreenshot(named: "02_mock_connected", app: app)

        let captureButton = app.buttons["capturePhotoButton"]
        XCTAssertTrue(captureButton.waitForExistence(timeout: 10))
        captureButton.tap()

        let shortDescription = app.staticTexts["shortDescriptionText"]
        XCTAssertTrue(shortDescription.waitForExistence(timeout: 20))
        XCTAssertTrue(shortDescription.label.contains("mock") || shortDescription.label.count > 0)
        attachScreenshot(named: "03_ai_description_visible", app: app)

        let replayButton = app.buttons["replayButton"]
        XCTAssertTrue(replayButton.waitForExistence(timeout: 10))
        attachScreenshot(named: "04_final_state", app: app)
    }

    private func attachScreenshot(named name: String, app: XCUIApplication) {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
