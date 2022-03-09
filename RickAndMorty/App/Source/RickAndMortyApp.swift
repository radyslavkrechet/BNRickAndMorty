// Copyright © Radyslav Krechet. All rights reserved.

import SwiftUI

@main
struct RickAndMortyApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                CharactersCollectionContainerView(viewModel: .init())
                    .tabItem {
                        Label("tab_label_characters", systemImage: "person.text.rectangle")
                    }
                EpisodesListContainerView(viewModel: .init())
                    .tabItem {
                        Label("tab_label_episodes", systemImage: "list.and.film")
                    }
            }
        }
    }
}
