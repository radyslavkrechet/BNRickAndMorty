// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

enum CharactersCollectionContainerViewState {
    case idle
    case loading
    case loaded(CharactersCollectionContentViewModel)
    case failure(ErrorViewModel)
}

struct CharactersCollectionContainerView: View {
    @ObservedObject var viewModel: CharactersCollectionViewModel

    var body: some View {
        NavigationView {
            content
                .navigationTitle("characters_collection_navigation_title")
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
        case .loading:
            LoadingView()
        case .loaded(let viewModel):
            CharactersCollectionContentView(viewModel: viewModel)
        case .failure(let viewModel):
            ErrorView(viewModel: viewModel)
        }
    }
}
