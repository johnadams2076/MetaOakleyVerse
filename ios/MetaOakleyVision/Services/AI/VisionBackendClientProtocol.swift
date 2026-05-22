import Foundation

protocol VisionBackendClientProtocol {
    func describePhoto(imageData: Data, question: String?) async throws -> DescribePhotoResponse
    func describeVideo(frames: [Data], question: String?) async throws -> DescribeVideoResponse
    func requestBackgroundEdit(media: CapturedMedia, prompt: String?) async throws -> BackgroundEditResponse
}
