// Copyright © Radyslav Krechet. All rights reserved.

import Combine
import Foundation

final class EpisodeDetailsViewModel: ObservableObject {
    @Published private(set) var state = EpisodeDetailsContainerViewState.idle

    func load() {
        switch state {
        case .idle, .failure:
            break
        default:
            return
        }
        state = .loading
        episodeService.getEpisode(id: id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if let self = self, case .failure(let error) = completion {
                        self.state = self.buildFailureState(error)
                    }
                },
                receiveValue: { [weak self] value in
                    if let self = self {
                        self.state = self.buildLoadedState(value)
                    }
                }
            )
            .store(in: &bag)
    }

    private let id: Int
    private var episodeService: EpisodeServiceType
    private var bag = Set<AnyCancellable>()

    init(id: Int, episodeService: EpisodeServiceType) {
        self.id = id
        self.episodeService = episodeService
    }

    convenience init(id: Int) {
        self.init(id: id, episodeService: ServiceFactory.episodeService)
    }

    private func buildLoadedState(_ episode: EpisodeDTO) -> EpisodeDetailsContainerViewState {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return .loaded(
            .init(
                header: .init(
                    title: episode.name,
                    number: episode.number,
                    season: episode.season,
                    airDate: dateFormatter.string(from: episode.airDate)
                ),
                someAppearedCharacters: episode.someAppearedCharacters.map { character in
                    .init(id: character.id, imageURL: character.imageURL, title: character.name)
                }
            )
        )
    }

    private func buildFailureState(_ error: DomainError) -> EpisodeDetailsContainerViewState {
        .failure(
            .init(message: error.localizedDescription) { [weak self] in
                self?.load()
            }
        )
    }
}
