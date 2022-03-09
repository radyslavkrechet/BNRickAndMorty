// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

struct ErrorViewModel {
    let message: String
    let retryAction: () -> Void
}

struct ErrorView: View {
    let viewModel: ErrorViewModel

    var body: some View {
        VStack(spacing: 8) {
            Text(viewModel.message)
                .multilineTextAlignment(.center)
            Button("error_button_retry") {
                viewModel.retryAction()
            }
        }
    }
}

#if DEBUG
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(viewModel: .init(message: "Something went wrong") {})
    }
}
#endif
