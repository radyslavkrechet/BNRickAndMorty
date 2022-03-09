// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

struct EpisodesListContentViewModel {
    let episodes: [EpisodesListRowViewModel]
    let loadNext: () -> Void
}

struct EpisodesListContentView: View {
    let viewModel: EpisodesListContentViewModel

    var body: some View {
        List(viewModel.episodes) { episode in
            EpisodesListRowView(viewModel: episode)
                .onAppear {
                    if episode.id == viewModel.episodes.last?.id {
                        viewModel.loadNext()
                    }
                }
        }
        .listStyle(.plain)
    }
}

#if DEBUG
struct EpisodesListContentView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodesListContentView(viewModel: .init(episodes: [.init(id: 1, season: 1, title: "S1 E1")]) {})
    }
}
#endif
