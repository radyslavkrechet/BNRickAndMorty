// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

enum CharacterDetailsContainerViewState {
    case idle
    case loading
    case loaded(CharacterDetailsContentViewModel)
    case failure(ErrorViewModel)
}

struct CharacterDetailsContainerView: View {
    @ObservedObject var viewModel: CharacterDetailsViewModel

    var body: some View {
        content
            .navigationTitle("character_details_navigation_title")
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
            CharacterDetailsContentView(viewModel: viewModel)
        case .failure(let viewModel):
            ErrorView(viewModel: viewModel)
        }
    }
}
