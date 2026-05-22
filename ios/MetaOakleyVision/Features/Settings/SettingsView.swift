import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()

    var body: some View {
        VStack(spacing: 12) {
            Text(viewModel.title)
                .font(.title2.bold())
                .accessibilityIdentifier("settingsTitle")
            Text("Mock mode is active for this demo build.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .accessibilityIdentifier("settingsSubtitle")
        }
        .padding()
        .navigationTitle("Settings")
    }
}
