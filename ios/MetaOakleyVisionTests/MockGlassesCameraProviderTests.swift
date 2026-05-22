import XCTest
@testable import MetaOakleyVision

final class MockGlassesCameraProviderTests: XCTestCase {
    func testConnectAndCaptureReturnsImageData() async throws {
        let provider = MockGlassesCameraProvider(connectDelayNanoseconds: 1_000)
        try await provider.configure()
        try await provider.connect()
        let media = try await provider.capturePhoto()
        XCTAssertEqual(media.type, .photo)
        XCTAssertNotNil(media.jpegData)
        XCTAssertFalse(media.jpegData?.isEmpty ?? true)
    }

    func testPermissionDeniedMapsToAppError() async {
        let provider = MockGlassesCameraProvider(connectDelayNanoseconds: 1_000, forcePermissionDenied: true)
        do {
            try await provider.connect()
            XCTFail("Expected permission denied")
        } catch let error as AppError {
            if case .permissionDenied = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Unexpected app error: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type")
        }
    }
}
