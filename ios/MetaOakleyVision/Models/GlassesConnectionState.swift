enum GlassesConnectionState: Equatable {
    case disconnected
    case connecting
    case mockConnected
    case realConnected
    case permissionNeeded(String)
    case error(String)

    var displayText: String {
        switch self {
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting"
        case .mockConnected:
            return "Mock Connected"
        case .realConnected:
            return "Glasses Connected"
        case .permissionNeeded:
            return "Permission Needed"
        case .error:
            return "Error"
        }
    }
}
