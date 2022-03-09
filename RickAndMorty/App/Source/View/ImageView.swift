// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

struct ImageViewModel {
    enum Context {
        case charactersFeaturedCollection
        case charactersGenderCollection
        case characterRow
        case characterDetails

        var size: CGFloat {
            switch self {
            case .charactersFeaturedCollection:
                return 300
            case .charactersGenderCollection:
                return 150
            case .characterRow:
                return 100
            case .characterDetails:
                return 200
            }
        }
    }

    let url: URL
    let context: Context
}

struct ImageView: View {
    let viewModel: ImageViewModel

    var body: some View {
        AsyncImage(url: viewModel.url, transaction: .init(animation: .default)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .transition(.opacity)
            } else if phase.error != nil {
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            } else {
                ProgressView()
            }
        }
        .frame(width: viewModel.context.size, height: viewModel.context.size)
        .background(.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
