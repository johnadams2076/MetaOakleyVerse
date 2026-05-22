import SwiftUI

struct ConnectView: View {
    @StateObject var viewModel = ConnectViewModel()

    var body: some View {
        Text(viewModel.title)
    }
}
