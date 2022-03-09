// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

enum CharactersListContainerViewState {
    case idle
    case loading(CharactersListContentViewModel)
    case loaded(CharactersListContentViewModel)
    case failure(ErrorViewModel)
}

struct CharactersListContainerView: View {
    @ObservedObject var viewModel: CharactersListViewModel

    var body: some View {
        content
            .navigationTitle(viewModel.navigationTitle)
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
        case .loading(let viewModel) where viewModel.characters.isEmpty:
            LoadingView()
        case .loaded(let viewModel) where viewModel.characters.isEmpty:
            EmptyView(viewModel: .init(message: NSLocalizedString("characters_list_empty_message", comment: "")))
        case .loading(let viewModel), .loaded(let viewModel):
            CharactersListContentView(viewModel: viewModel)
        case .failure(let viewModel):
            ErrorView(viewModel: viewModel)
        }
    }
}
