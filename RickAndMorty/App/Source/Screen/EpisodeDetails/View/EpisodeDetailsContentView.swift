// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

struct EpisodeDetailsContentViewModel {
    let header: EpisodeDetailsHeaderViewModel
    let someAppearedCharacters: [CharacterRowViewModel]
}

struct EpisodeDetailsContentView: View {
    let viewModel: EpisodeDetailsContentViewModel

    var body: some View {
        List {
            EpisodeDetailsHeaderView(viewModel: viewModel.header)
            Text("episode_details_section_header")
                .font(.headline)
            ForEach(viewModel.someAppearedCharacters) { character in
                CharacterRowView(viewModel: character)
            }
        }
        .listStyle(.plain)
    }
}

#if DEBUG
struct EpisodeDetailsContentView_Previews: PreviewProvider {
    static var previews: some View {
        guard let imageURL = URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg") else {
            fatalError("Image URL is not valid")
        }
        let header = EpisodeDetailsHeaderViewModel(title: "Pilot", number: 1, season: 1, airDate: "Dec 2, 2013")
        let someAppearedCharacters: [CharacterRowViewModel] = [.init(id: 1, imageURL: imageURL, title: "Rick Sanchez")]
        let viewModel = EpisodeDetailsContentViewModel(header: header, someAppearedCharacters: someAppearedCharacters)
        return EpisodeDetailsContentView(viewModel: viewModel)
    }
}
#endif
