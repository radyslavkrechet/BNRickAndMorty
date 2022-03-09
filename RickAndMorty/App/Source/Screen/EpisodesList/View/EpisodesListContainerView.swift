// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

enum EpisodesListContainerViewState {
    case idle
    case loading(EpisodesListContentViewModel)
    case loaded(EpisodesListContentViewModel)
    case failure(ErrorViewModel)
}

struct EpisodesListContainerView: View {
    @ObservedObject var viewModel: EpisodesListViewModel

    var body: some View {
        NavigationView {
            content
                .navigationTitle("episodes_list_navigation_title")
                .onAppear {
                    viewModel.load()
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            Color.clear
        case .loading(let viewModel) where viewModel.episodes.isEmpty:
            LoadingView()
        case .loaded(let viewModel) where viewModel.episodes.isEmpty:
            EmptyView(viewModel: .init(message: NSLocalizedString("episodes_list_empty_message", comment: "")))
        case .loading(let viewModel), .loaded(let viewModel):
            EpisodesListContentView(viewModel: viewModel)
        case .failure(let viewModel):
            ErrorView(viewModel: viewModel)
        }
    }
}
