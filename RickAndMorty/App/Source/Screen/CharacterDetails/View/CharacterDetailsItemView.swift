// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

struct CharacterDetailsItemViewModel {
    let title: String
    let body: String
}

struct CharacterDetailsItemView: View {
    let viewModel: CharacterDetailsItemViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.title)
                .font(.headline)
            Text(viewModel.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
