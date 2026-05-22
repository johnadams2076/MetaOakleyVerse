import SwiftUI

struct CaptureView: View {
    @ObservedObject var viewModel: CaptureViewModel
    let appConfig: AppConfig

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Meta Oakley Vision")
                    .font(.largeTitle.bold())
                    .accessibilityIdentifier("appTitle")

                Text(viewModel.connectionStatus.displayText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.blue.opacity(0.15))
                    .clipShape(Capsule())
                    .accessibilityIdentifier("connectionStatus")

                Text(viewModel.modeText)
                    .accessibilityIdentifier("modeLabel")

                HStack {
                    Button("Connect") {
                        Task { await viewModel.connect() }
                    }
                    .accessibilityIdentifier("connectButton")

                    Button("Capture Photo") {
                        Task { await viewModel.capturePhoto() }
                    }
                    .accessibilityIdentifier("capturePhotoButton")
                }

                HStack {
                    Button("Ask About Video") {}
                        .accessibilityIdentifier("videoAssistButton")
                    Button("Background Edit") {}
                        .accessibilityIdentifier("backgroundEditButton")
                    Button("Settings") {}
                        .accessibilityIdentifier("settingsButton")
                }

                switch viewModel.state {
                case .idle:
                    Text("Ready")
                case .connecting:
                    ProgressView("Connecting...")
                case .connected:
                    Text("Connected")
                case .capturing:
                    ProgressView("Capturing...")
                case let .askingAI(imageData):
                    if let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 220)
                            .accessibilityIdentifier("capturedImage")
                    }
                    ProgressView("Asking AI...")
                case let .success(imageData, shortDescription, detailedDescription, _):
                    if let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 220)
                            .accessibilityIdentifier("capturedImage")
                    }
                    Text(shortDescription)
                        .font(.headline)
                        .accessibilityIdentifier("shortDescriptionText")
                    Text(detailedDescription)
                        .accessibilityIdentifier("detailedDescriptionText")
                    Button("Replay") {
                        Task { await viewModel.replaySpeech() }
                    }
                    .accessibilityIdentifier("replayButton")
                case let .error(message):
                    Text(message)
                        .foregroundStyle(.red)
                        .accessibilityIdentifier("errorBanner")
                }
            }
            .padding()
        }
    }
}
