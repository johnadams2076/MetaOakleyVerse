import Foundation

final class DATGlassesCameraProvider: GlassesCameraProviding {
    var connectionState: AsyncStream<GlassesConnectionState> {
        AsyncStream { continuation in
            continuation.yield(.disconnected)
            continuation.finish()
        }
    }

    func configure() async throws {
        throw AppError.unsupportedFeature("DAT provider is not enabled in this MVP build.")
    }

    func connect() async throws {
        throw AppError.unsupportedFeature("DAT provider is not enabled in this MVP build.")
    }

    func disconnect() async {}

    func capturePhoto() async throws -> CapturedMedia {
        throw AppError.unsupportedFeature("DAT photo capture is not enabled in this MVP build.")
    }

    func startVideoStream() async throws -> AsyncStream<VideoFrame> {
        throw AppError.unsupportedFeature("DAT video stream is not enabled in this MVP build.")
    }

    func stopVideoStream() async {}
}
