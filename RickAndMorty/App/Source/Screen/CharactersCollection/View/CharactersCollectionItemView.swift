// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

struct CharactersCollectionItemViewModel: Identifiable {
    let id: Int
    let image: ImageViewModel
    let title: String
}

struct CharactersCollectionItemView: View {
    let viewModel: CharactersCollectionItemViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ImageView(viewModel: .init(url: viewModel.image.url, context: viewModel.image.context))
            Text(viewModel.title)
                .foregroundColor(.primary)
                .frame(maxWidth: viewModel.image.context.size, alignment: .leading)
                .lineLimit(1)
        }
        .background {
            NavigationLink(
                isActive: $isCharacterDetailsActive,
                destination: {
                    CharacterDetailsContainerView(viewModel: .init(id: viewModel.id))
                },
                label: {}
            )
            .hidden()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isCharacterDetailsActive = true
        }
    }

    @State private var isCharacterDetailsActive = false
}
