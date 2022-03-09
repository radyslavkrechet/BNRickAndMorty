// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

struct EmptyViewModel {
    let message: String
}

struct EmptyView: View {
    let viewModel: EmptyViewModel

    var body: some View {
        Text(viewModel.message)
            .foregroundColor(Color.gray)
            .multilineTextAlignment(.center)
    }
}

#if DEBUG
struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView(viewModel: .init(message: "No items"))
    }
}
#endif
