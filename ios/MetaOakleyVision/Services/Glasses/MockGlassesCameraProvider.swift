import Foundation
import UIKit

final class MockGlassesCameraProvider: GlassesCameraProviding {
    private let connectDelayNanoseconds: UInt64
    private let forcePermissionDenied: Bool
    private var currentState: GlassesConnectionState = .disconnected
    private var stateContinuation: AsyncStream<GlassesConnectionState>.Continuation?

    lazy var connectionState: AsyncStream<GlassesConnectionState> = {
        AsyncStream { continuation in
            self.stateContinuation = continuation
            continuation.yield(self.currentState)
        }
    }()

    init(connectDelayNanoseconds: UInt64 = 250_000_000, forcePermissionDenied: Bool = false) {
        self.connectDelayNanoseconds = connectDelayNanoseconds
        self.forcePermissionDenied = forcePermissionDenied
    }

    func configure() async throws {}

    func connect() async throws {
        currentState = .connecting
        stateContinuation?.yield(.connecting)
        try await Task.sleep(nanoseconds: connectDelayNanoseconds)

        if forcePermissionDenied {
            let message = "Bluetooth permission denied"
            currentState = .permissionNeeded(message)
            stateContinuation?.yield(.permissionNeeded(message))
            throw AppError.permissionDenied(message)
        }

        currentState = .mockConnected
        stateContinuation?.yield(.mockConnected)
    }

    func disconnect() async {
        currentState = .disconnected
        stateContinuation?.yield(.disconnected)
    }

    func capturePhoto() async throws -> CapturedMedia {
        guard currentState == .mockConnected else {
            throw AppError.glassesNotConnected
        }

        let data = try loadMockJPEGData()
        return CapturedMedia(
            id: UUID(),
            type: .photo,
            jpegData: data,
            localFileURL: nil,
            createdAt: Date()
        )
    }

    func startVideoStream() async throws -> AsyncStream<VideoFrame> {
        AsyncStream { continuation in
            continuation.finish()
        }
    }

    func stopVideoStream() async {}

    private func loadMockJPEGData() throws -> Data {
        if let url = Bundle.main.url(forResource: "mock_scene_01", withExtension: "jpg", subdirectory: "MockMedia"),
           let data = try? Data(contentsOf: url),
           UIImage(data: data) != nil {
            return data
        }

        guard let fallback = Data(base64Encoded: Self.fallbackJPEGBase64) else {
            throw AppError.captureFailed("Mock image missing")
        }
        return fallback
    }

    private static let fallbackJPEGBase64 = "/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxAQEBAQEA8PEA8QDw8PDw8QDw8PEA8QFxUWFhURFRUYHSggGBolHRUVITEhJSkrLi4uFx8zODMtNygtLisBCgoKDg0OGxAQGy0fICUtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIAAEAAQMBIgACEQEDEQH/xAAWAAEBAQAAAAAAAAAAAAAAAAAAAQL/xAAXAQEBAQEAAAAAAAAAAAAAAAAAAQID/9oADAMBAAIQAxAAAAHkJf/EABYQAQEBAAAAAAAAAAAAAAAAAAABEf/aAAgBAQABBQJqf//EABYRAQEBAAAAAAAAAAAAAAAAAAABEf/aAAgBAwEBPwGx/8QAFhEBAQEAAAAAAAAAAAAAAAAAABEh/9oACAECAQE/AbH/xAAXEAADAQAAAAAAAAAAAAAAAAAAAREh/9oACAEBAAY/Asqf/8QAFxABAQEBAAAAAAAAAAAAAAAAAREAITFhcf/aAAgBAQABPyG4rBQ6k//aAAwDAQACAAMAAAAQ8//EABYRAQEBAAAAAAAAAAAAAAAAAAABEf/aAAgBAwEBPxAq/8QAFxEBAQEBAAAAAAAAAAAAAAAAAREAITFh/9oACAECAQE/EE8h0//EABoQAQEAAwEBAAAAAAAAAAAAAAERACExQWFxgaH/2gAIAQEAAT8QfITqA4rN8GlyBvXNRlT/2Q=="
}
