import XCTest
@testable import MetaOakleyVision

@MainActor
final class CaptureViewModelTests: XCTestCase {
    func testInitialStateIsIdle() {
        let vm = makeViewModel()
        XCTAssertEqual(vm.state, .idle)
    }

    func testConnectUpdatesStatusToMockConnected() async {
        let provider = MockGlassesCameraProvider(connectDelayNanoseconds: 1_000)
        let vm = makeViewModel(provider: provider)
        await vm.connect()
        XCTAssertEqual(vm.connectionStatus, .mockConnected)
    }

    func testCaptureUsesProviderBackendAndSpeech() async {
        let provider = MockGlassesCameraProvider(connectDelayNanoseconds: 1_000)
        let backend = MockVisionBackendClient()
        let speech = MockSpeechService()
        let vm = makeViewModel(provider: provider, backend: backend, speech: speech)

        await vm.connect()
        await vm.capturePhoto()

        if case let .success(_, shortDescription, detailedDescription, spokenResponse) = vm.state {
            XCTAssertFalse(shortDescription.isEmpty)
            XCTAssertFalse(detailedDescription.isEmpty)
            XCTAssertFalse(spokenResponse.isEmpty)
        } else {
            XCTFail("Expected success state")
        }

        XCTAssertNotNil(speech.lastSpokenText)
    }

    func testBackendErrorShowsUserFriendlyError() async {
        let provider = MockGlassesCameraProvider(connectDelayNanoseconds: 1_000)
        let vm = makeViewModel(provider: provider, backend: FailingBackendClient(), speech: MockSpeechService())

        await vm.connect()
        await vm.capturePhoto()

        if case let .error(message) = vm.state {
            XCTAssertFalse(message.isEmpty)
        } else {
            XCTFail("Expected error state")
        }
    }

    private func makeViewModel(
        provider: GlassesCameraProviding = MockGlassesCameraProvider(connectDelayNanoseconds: 1_000),
        backend: VisionBackendClientProtocol = MockVisionBackendClient(),
        speech: SpeechSpeaking = MockSpeechService()
    ) -> CaptureViewModel {
        CaptureViewModel(
            glassesProvider: provider,
            backendClient: backend,
            speechService: speech,
            appConfig: .debugDefault
        )
    }
}

private struct FailingBackendClient: VisionBackendClientProtocol {
    func describePhoto(imageData: Data, question: String?) async throws -> DescribePhotoResponse {
        _ = imageData
        _ = question
        throw AppError.backendUnavailable
    }

    func describeVideo(frames: [Data], question: String?) async throws -> DescribeVideoResponse {
        _ = frames
        _ = question
        throw AppError.unsupportedFeature("Not used")
    }

    func requestBackgroundEdit(media: CapturedMedia, prompt: String?) async throws -> BackgroundEditResponse {
        _ = media
        _ = prompt
        throw AppError.unsupportedFeature("Not used")
    }
}
