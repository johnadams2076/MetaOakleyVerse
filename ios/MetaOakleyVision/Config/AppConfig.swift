import Foundation

struct AppConfig: Equatable {
    enum GlassesMode: String, Equatable {
        case mock
        case real
    }

    var backendBaseURL: URL
    var glassesMode: GlassesMode
    var enableMockAI: Bool
    var disableRealSpeech: Bool
    var videoFrameSampleFPS: Double
    var maxFramesPerVideoQuestion: Int
    var backgroundPromptTimeoutSeconds: Double

    static let debugDefault = AppConfig(
        backendBaseURL: URL(string: "http://127.0.0.1:8787")!,
        glassesMode: .mock,
        enableMockAI: true,
        disableRealSpeech: false,
        videoFrameSampleFPS: 1.0,
        maxFramesPerVideoQuestion: 8,
        backgroundPromptTimeoutSeconds: 8
    )
}
