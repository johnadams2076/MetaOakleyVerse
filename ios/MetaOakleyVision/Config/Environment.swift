import Foundation

struct AppContainer {
    let appConfig: AppConfig
    let glassesProvider: GlassesCameraProviding
    let backendClient: VisionBackendClientProtocol
    let speechService: SpeechSpeaking
}

enum AppEnvironment {
    static func makeContainer(
        arguments: [String] = ProcessInfo.processInfo.arguments
    ) -> AppContainer {
        let appConfig = makeConfig(arguments: arguments)
        let glassesProvider: GlassesCameraProviding = appConfig.glassesMode == .mock
            ? MockGlassesCameraProvider()
            : DATGlassesCameraProvider()

        let backendClient: VisionBackendClientProtocol = appConfig.enableMockAI
            ? MockVisionBackendClient()
            : VisionBackendClient(baseURL: appConfig.backendBaseURL)

        let speechService: SpeechSpeaking = appConfig.disableRealSpeech
            ? MockSpeechService()
            : IOSSpeechService(disabled: false)

        return AppContainer(
            appConfig: appConfig,
            glassesProvider: glassesProvider,
            backendClient: backendClient,
            speechService: speechService
        )
    }

    static func makeConfig(arguments: [String]) -> AppConfig {
        var config = AppConfig.debugDefault

        if arguments.contains("--mock-glasses") {
            config.glassesMode = .mock
        }
        if arguments.contains("--real-glasses") {
            config.glassesMode = .real
        }
        if arguments.contains("--mock-ai") {
            config.enableMockAI = true
        }
        if arguments.contains("--disable-real-speech") {
            config.disableRealSpeech = true
        }

        if let backendIndex = arguments.firstIndex(of: "--backend-url"),
           backendIndex + 1 < arguments.count,
           let backendURL = URL(string: arguments[backendIndex + 1]) {
            config.backendBaseURL = backendURL
        }

        return config
    }
}
