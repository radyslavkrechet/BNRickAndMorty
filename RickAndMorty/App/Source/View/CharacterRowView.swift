// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

struct CharacterRowViewModel: Identifiable {
    let id: Int
    let imageURL: URL
    let title: String
}

struct CharacterRowView: View {
    let viewModel: CharacterRowViewModel

    var body: some View {
        NavigationLink(
            destination: {
                CharacterDetailsContainerView(viewModel: .init(id: viewModel.id))
            },
            label: {
                HStack(spacing: 16) {
                    ImageView(viewModel: .init(url: viewModel.imageURL, context: .characterRow))
                    Text(viewModel.title)
                        .lineLimit(1)
                }
            }
        )
    }
}
