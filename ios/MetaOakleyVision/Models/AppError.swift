import Foundation

enum AppError: Error, Equatable, LocalizedError {
    case glassesNotConnected
    case permissionDenied(String)
    case captureFailed(String)
    case backendUnavailable
    case invalidBackendResponse
    case aiProviderError(String)
    case unsupportedFeature(String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .glassesNotConnected:
            return "Glasses are not connected. Connect or switch to mock mode."
        case let .permissionDenied(message):
            return "Permission is required. \(message)"
        case let .captureFailed(message):
            return "Could not capture from glasses. \(message)"
        case .backendUnavailable:
            return "The AI server is not reachable. Check backend URL and network."
        case .invalidBackendResponse:
            return "The AI server returned an invalid response."
        case let .aiProviderError(message):
            return "AI provider error: \(message)"
        case let .unsupportedFeature(message):
            return "Unsupported feature: \(message)"
        case let .unknown(message):
            return message
        }
    }
}
