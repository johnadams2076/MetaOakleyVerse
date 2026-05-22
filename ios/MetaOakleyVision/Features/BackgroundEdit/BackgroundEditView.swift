import SwiftUI

struct BackgroundEditView: View {
    @StateObject var viewModel = BackgroundEditViewModel()

    var body: some View {
        Text(viewModel.title)
    }
}
