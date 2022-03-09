// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

struct EpisodeDetailsHeaderViewModel {
    let title: String
    let number: Int
    let season: Int
    let airDate: String
}

struct EpisodeDetailsHeaderView: View {
    let viewModel: EpisodeDetailsHeaderViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.title)
                .font(.title)
                .fontWeight(.semibold)
            Text("episode_details_text_episode \(viewModel.number)")
            Text("episode_details_text_season \(viewModel.season)")
            Text("episode_details_text_air_date \(viewModel.airDate)")
                .font(.footnote)
                .foregroundColor(Color.gray)
        }
        .padding(.vertical, 8)
    }
}
