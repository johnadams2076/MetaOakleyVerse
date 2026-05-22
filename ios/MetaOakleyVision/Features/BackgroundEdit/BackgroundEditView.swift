import SwiftUI

struct BackgroundEditView: View {
    @StateObject var viewModel = BackgroundEditViewModel()

    var body: some View {
        VStack(spacing: 12) {
            Text(viewModel.title)
                .font(.title2.bold())
                .accessibilityIdentifier("backgroundEditTitle")
            Text("Background replacement workflow is planned in the next milestone.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .accessibilityIdentifier("backgroundEditSubtitle")
        }
        .padding()
        .navigationTitle("Background Edit")
    }
}
