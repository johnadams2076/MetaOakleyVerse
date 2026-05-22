import SwiftUI

@main
struct MetaOakleyVisionApp: App {
    private let container = AppEnvironment.makeContainer()

    var body: some Scene {
        WindowGroup {
            AppRootView(container: container)
        }
    }
}
