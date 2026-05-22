protocol SpeechSpeaking {
    func speak(_ text: String) async
    func stop()
}
