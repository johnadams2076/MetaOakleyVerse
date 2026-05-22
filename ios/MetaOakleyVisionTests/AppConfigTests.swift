import XCTest
@testable import MetaOakleyVision

final class AppConfigTests: XCTestCase {
    func testParsesMockFlagsAndBackendURL() {
        let args = [
            "MetaOakleyVision",
            "--mock-glasses",
            "--mock-ai",
            "--disable-real-speech",
            "--backend-url",
            "http://localhost:8787"
        ]

        let config = AppEnvironment.makeConfig(arguments: args)
        XCTAssertEqual(config.glassesMode, .mock)
        XCTAssertTrue(config.enableMockAI)
        XCTAssertTrue(config.disableRealSpeech)
        XCTAssertEqual(config.backendBaseURL.host, "localhost")
        XCTAssertEqual(config.backendBaseURL.port, 8787)
    }
}
