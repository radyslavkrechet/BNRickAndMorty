// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

struct CharacterDetailsContentViewModel {
    let header: CharacterDetailsHeaderViewModel
    let items: [CharacterDetailsItemViewModel]
}

struct CharacterDetailsContentView: View {
    let viewModel: CharacterDetailsContentViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Divider()
                CharacterDetailsHeaderView(viewModel: viewModel.header)
                ForEach(viewModel.items, id: \.title) { item in
                    Divider()
                    CharacterDetailsItemView(viewModel: item)
                }
            }
            .padding(.horizontal)
        }
    }
}

#if DEBUG
struct CharacterDetailsContentView_Previews: PreviewProvider {
    static var previews: some View {
        guard let imageURL = URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg") else {
            fatalError("Image URL is not valid")
        }
        let header = CharacterDetailsHeaderViewModel(imageURL: imageURL, title: "Rick Sanchez")
        let items: [CharacterDetailsItemViewModel] = [.init(title: "Status", body: "Alive")]
        return CharacterDetailsContentView(viewModel: .init(header: header, items: items))
    }
}
#endif
