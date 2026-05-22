import Foundation

@MainActor
final class CaptureViewModel: ObservableObject {
    enum CaptureUiState: Equatable {
        case idle
        case connecting
        case connected(GlassesConnectionState)
        case capturing
        case askingAI(imageData: Data)
        case success(imageData: Data, shortDescription: String, detailedDescription: String, spokenResponse: String)
        case error(String)
    }

    @Published private(set) var state: CaptureUiState = .idle
    @Published private(set) var connectionStatus: GlassesConnectionState = .disconnected

    private let glassesProvider: GlassesCameraProviding
    private let backendClient: VisionBackendClientProtocol
    private let speechService: SpeechSpeaking
    private let appConfig: AppConfig
    private var stateListenerTask: Task<Void, Never>?

    init(
        glassesProvider: GlassesCameraProviding,
        backendClient: VisionBackendClientProtocol,
        speechService: SpeechSpeaking,
        appConfig: AppConfig
    ) {
        self.glassesProvider = glassesProvider
        self.backendClient = backendClient
        self.speechService = speechService
        self.appConfig = appConfig
        listenConnectionState()
    }

    deinit {
        stateListenerTask?.cancel()
    }

    func connect() async {
        state = .connecting
        do {
            try await glassesProvider.configure()
            try await glassesProvider.connect()
            connectionStatus = appConfig.glassesMode == .mock ? .mockConnected : .realConnected
            state = .connected(connectionStatus)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? "Failed to connect"
            connectionStatus = .error(message)
            state = .error(message)
        }
    }

    func capturePhoto() async {
        state = .capturing
        do {
            let media = try await glassesProvider.capturePhoto()
            guard let imageData = media.jpegData else {
                throw AppError.captureFailed("No image bytes returned")
            }

            state = .askingAI(imageData: imageData)
            let response = try await backendClient.describePhoto(imageData: imageData, question: nil)
            state = .success(
                imageData: imageData,
                shortDescription: response.shortDescription,
                detailedDescription: response.detailedDescription,
                spokenResponse: response.spokenResponse
            )
            await speechService.speak(response.spokenResponse)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? "Capture failed"
            state = .error(message)
        }
    }

    func replaySpeech() async {
        if case let .success(_, _, _, spokenResponse) = state {
            await speechService.speak(spokenResponse)
        }
    }

    private func listenConnectionState() {
        stateListenerTask = Task { [weak self] in
            guard let self else { return }
            for await state in glassesProvider.connectionState {
                self.connectionStatus = state
            }
        }
    }

    var modeText: String {
        appConfig.glassesMode == .mock ? "Mode: Mock" : "Mode: Real"
    }
}
