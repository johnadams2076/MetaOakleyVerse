import SwiftUI

struct AppRootView: View {
    let container: AppContainer
    @StateObject private var captureViewModel: CaptureViewModel

    init(container: AppContainer) {
        self.container = container
        _captureViewModel = StateObject(
            wrappedValue: CaptureViewModel(
                glassesProvider: container.glassesProvider,
                backendClient: container.backendClient,
                speechService: container.speechService,
                appConfig: container.appConfig
            )
        )
    }

    var body: some View {
        NavigationStack {
            CaptureView(viewModel: captureViewModel, appConfig: container.appConfig)
        }
    }
}
