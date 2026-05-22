import Foundation

final class MockSpeechService: SpeechSpeaking {
    private(set) var lastSpokenText: String?

    func speak(_ text: String) async {
        lastSpokenText = text
    }

    func stop() {
        lastSpokenText = nil
    }
}
