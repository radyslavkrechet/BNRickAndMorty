// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

struct CharactersCollectionRowViewModel: Identifiable {
    enum Kind {
        case featured
        case gender(Gender)
    }

    let id: String
    let kind: Kind
    let characters: [CharactersCollectionItemViewModel]
}

struct CharactersCollectionRowView: View {
    let viewModel: CharactersCollectionRowViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                if case .gender(let gender) = viewModel.kind {
                    Spacer()
                    Button("characters_collection_row_button_see_all") {
                        isCharactersListActive = true
                    }
                    .background {
                        NavigationLink(
                            isActive: $isCharactersListActive,
                            destination: {
                                CharactersListContainerView(viewModel: .init(gender: gender))
                            },
                            label: {}
                        )
                        .hidden()
                    }
                }
            }
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.characters) { characters in
                        CharactersCollectionItemView(viewModel: characters)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
    }

    @State private var isCharactersListActive = false

    private var title: String {
        switch viewModel.kind {
        case .featured:
            return NSLocalizedString("characters_collection_row_title_featured", comment: "")
        case .gender(let gender):
            return gender.title
        }
    }
}
