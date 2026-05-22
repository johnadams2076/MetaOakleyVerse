import SwiftUI

struct VideoAssistView: View {
    @StateObject var viewModel = VideoAssistViewModel()

    var body: some View {
        VStack(spacing: 12) {
            Text(viewModel.title)
                .font(.title2.bold())
                .accessibilityIdentifier("videoAssistTitle")
            Text("Video Q&A flow is planned in the next milestone.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .accessibilityIdentifier("videoAssistSubtitle")
        }
        .padding()
        .navigationTitle("Video Assist")
    }
}
