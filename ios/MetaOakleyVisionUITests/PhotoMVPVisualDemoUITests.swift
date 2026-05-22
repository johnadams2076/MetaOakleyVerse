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

        let capturedImage = app.images["capturedImage"]
        XCTAssertTrue(capturedImage.waitForExistence(timeout: 10))
        attachScreenshot(named: "03_captured_image_visible", app: app)
        attachScreenshot(named: "04_ai_description_visible", app: app)

        let replayButton = app.buttons["replayButton"]
        XCTAssertTrue(replayButton.waitForExistence(timeout: 10))
        attachScreenshot(named: "05_final_state", app: app)
    }

    func testFullFeatureCinemaFlow() throws {
        let app = XCUIApplication()
        app.launchArguments = [
            "--mock-glasses",
            "--mock-ai",
            "--disable-real-speech"
        ]
        app.launch()

        let title = app.staticTexts["appTitle"]
        XCTAssertTrue(title.waitForExistence(timeout: 10))
        attachScreenshot(named: "10_cinema_app_launched", app: app)

        let settingsButton = app.buttons["settingsButton"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 10))
        settingsButton.tap()
        XCTAssertTrue(app.staticTexts["settingsTitle"].waitForExistence(timeout: 10))
        attachScreenshot(named: "11_cinema_settings", app: app)
        app.navigationBars.buttons.element(boundBy: 0).tap()

        let videoButton = app.buttons["videoAssistButton"]
        XCTAssertTrue(videoButton.waitForExistence(timeout: 10))
        videoButton.tap()
        XCTAssertTrue(app.staticTexts["videoAssistTitle"].waitForExistence(timeout: 10))
        attachScreenshot(named: "12_cinema_video_assist", app: app)
        app.navigationBars.buttons.element(boundBy: 0).tap()

        let backgroundButton = app.buttons["backgroundEditButton"]
        XCTAssertTrue(backgroundButton.waitForExistence(timeout: 10))
        backgroundButton.tap()
        XCTAssertTrue(app.staticTexts["backgroundEditTitle"].waitForExistence(timeout: 10))
        attachScreenshot(named: "13_cinema_background_edit", app: app)
        app.navigationBars.buttons.element(boundBy: 0).tap()

        let connectButton = app.buttons["connectButton"]
        XCTAssertTrue(connectButton.waitForExistence(timeout: 10))
        connectButton.tap()

        let status = app.staticTexts["connectionStatus"]
        XCTAssertTrue(status.waitForExistence(timeout: 10))
        XCTAssertTrue(status.label.contains("Mock Connected"))
        attachScreenshot(named: "14_cinema_connected", app: app)

        let captureButton = app.buttons["capturePhotoButton"]
        XCTAssertTrue(captureButton.waitForExistence(timeout: 10))
        captureButton.tap()

        let capturedImage = app.images["capturedImage"]
        XCTAssertTrue(capturedImage.waitForExistence(timeout: 20))
        attachScreenshot(named: "15_cinema_captured_image", app: app)

        let shortDescription = app.staticTexts["shortDescriptionText"]
        XCTAssertTrue(shortDescription.waitForExistence(timeout: 10))
        attachScreenshot(named: "16_cinema_ai_text", app: app)

        let replayButton = app.buttons["replayButton"]
        XCTAssertTrue(replayButton.waitForExistence(timeout: 10))
        replayButton.tap()
        attachScreenshot(named: "17_cinema_replay_tapped", app: app)
    }

    private func attachScreenshot(named name: String, app: XCUIApplication) {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
