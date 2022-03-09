// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

struct CharactersListContentViewModel {
    let characters: [CharacterRowViewModel]
    let loadNext: () -> Void
}

struct CharactersListContentView: View {
    let viewModel: CharactersListContentViewModel

    var body: some View {
        List(viewModel.characters) { character in
            CharacterRowView(viewModel: character)
                .onAppear {
                    if character.id == viewModel.characters.last?.id {
                        viewModel.loadNext()
                    }
                }
        }
        .listStyle(.plain)
    }
}

#if DEBUG
struct CharactersListContentView_Previews: PreviewProvider {
    static var previews: some View {
        guard let imageURL = URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg") else {
            fatalError("Image URL is not valid")
        }
        let characters: [CharacterRowViewModel] = [.init(id: 1, imageURL: imageURL, title: "Rick Sanchez")]
        return CharactersListContentView(viewModel: .init(characters: characters) {})
    }
}
#endif
