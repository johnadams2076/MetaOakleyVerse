import AVFoundation

final class IOSSpeechService: NSObject, SpeechSpeaking {
    private let synthesizer = AVSpeechSynthesizer()
    private let disabled: Bool

    init(disabled: Bool) {
        self.disabled = disabled
    }

    func speak(_ text: String) async {
        guard !disabled else { return }
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
