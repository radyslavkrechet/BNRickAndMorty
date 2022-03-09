// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

struct CharactersCollectionContentViewModel {
    let collections: [CharactersCollectionRowViewModel]
}

struct CharactersCollectionContentView: View {
    let viewModel: CharactersCollectionContentViewModel

    var body: some View {
        ScrollView {
            VStack {
                Divider()
                    .padding(.leading)
                ForEach(viewModel.collections) { collection in
                    CharactersCollectionRowView(viewModel: collection)
                    Divider()
                        .padding(.leading)
                }
            }
        }
    }
}

#if DEBUG
struct CharactersCollectionContentView_Previews: PreviewProvider {
    static var previews: some View {
        let character: (Int, ImageViewModel.Context) -> CharactersCollectionItemViewModel = { id, context in
            guard let url = URL(string: "https://rickandmortyapi.com/api/character/avatar/\(id).jpeg") else {
                fatalError("Image URL is not valid")
            }
            return .init(id: id, image: .init(url: url, context: context), title: "Character \(id)")
        }
        let collections: [CharactersCollectionRowViewModel] = [
            .init(
                id: "featured",
                kind: .featured,
                characters: (1...2).map { character($0, .charactersFeaturedCollection) }
            ),
            .init(
                id: "female",
                kind: .gender(.female),
                characters: (3...5).map { character($0, .charactersGenderCollection) }
            )
        ]
        return CharactersCollectionContentView(viewModel: .init(collections: collections))
    }
}
#endif
