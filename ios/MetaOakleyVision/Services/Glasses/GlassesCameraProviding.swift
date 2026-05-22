import Foundation

protocol GlassesCameraProviding {
    var connectionState: AsyncStream<GlassesConnectionState> { get }
    func configure() async throws
    func connect() async throws
    func disconnect() async
    func capturePhoto() async throws -> CapturedMedia
    func startVideoStream() async throws -> AsyncStream<VideoFrame>
    func stopVideoStream() async
}
