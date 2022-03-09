// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

struct CharacterDetailsHeaderViewModel {
    let imageURL: URL
    let title: String
}

struct CharacterDetailsHeaderView: View {
    let viewModel: CharacterDetailsHeaderViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ImageView(viewModel: .init(url: viewModel.imageURL, context: .characterDetails))
            Text(viewModel.title)
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
        }
    }
}
