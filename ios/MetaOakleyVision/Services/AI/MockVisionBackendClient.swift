import Foundation

struct MockVisionBackendClient: VisionBackendClientProtocol {
    func describePhoto(imageData: Data, question: String?) async throws -> DescribePhotoResponse {
        _ = imageData
        _ = question
        return DescribePhotoResponse(
            requestId: "mock-request-id",
            shortDescription: "A mock scene description is ready.",
            detailedDescription: "This is a mock response for a captured glasses-style photo. It confirms that capture, upload, AI response parsing, display, and speech playback are wired correctly.",
            spokenResponse: "A mock scene description is ready.",
            safetyNotes: [],
            model: "mock-model",
            provider: "mock"
        )
    }

    func describeVideo(frames: [Data], question: String?) async throws -> DescribeVideoResponse {
        _ = frames
        _ = question
        throw AppError.unsupportedFeature("Video Q&A is not implemented in MVP.")
    }

    func requestBackgroundEdit(media: CapturedMedia, prompt: String?) async throws -> BackgroundEditResponse {
        _ = media
        _ = prompt
        throw AppError.unsupportedFeature("Background editing is not implemented in MVP.")
    }
}
