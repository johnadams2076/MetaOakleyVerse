import SwiftUI

struct VideoAssistView: View {
    @StateObject var viewModel = VideoAssistViewModel()

    var body: some View {
        Text(viewModel.title)
    }
}
