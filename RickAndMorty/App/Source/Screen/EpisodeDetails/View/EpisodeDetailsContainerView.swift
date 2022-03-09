// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

enum EpisodeDetailsContainerViewState {
    case idle
    case loading
    case loaded(EpisodeDetailsContentViewModel)
    case failure(ErrorViewModel)
}

struct EpisodeDetailsContainerView: View {
    @ObservedObject var viewModel: EpisodeDetailsViewModel

    var body: some View {
        content
            .navigationTitle("episode_details_navigation_title")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.load()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            Color.clear
        case .loading:
            LoadingView()
        case .loaded(let viewModel):
            EpisodeDetailsContentView(viewModel: viewModel)
        case .failure(let viewModel):
            ErrorView(viewModel: viewModel)
        }
    }
}
