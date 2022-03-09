// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

struct EpisodesListRowViewModel: Identifiable {
    let id: Int
    let season: Int
    let title: String
}

struct EpisodesListRowView: View {
    let viewModel: EpisodesListRowViewModel

    var body: some View {
        NavigationLink(
            destination: {
                EpisodeDetailsContainerView(viewModel: .init(id: viewModel.id))
            },
            label: {
                HStack(spacing: 16) {
                    Rectangle()
                        .fill(Color("season-\(viewModel.season)"))
                        .frame(width: 10, height: 50)
                        .cornerRadius(5)
                    Text(viewModel.title)
                }
            }
        )
    }
}
