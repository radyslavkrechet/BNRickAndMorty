// Copyright © Radyslav Krechet. All rights reserved.

import Combine
import Foundation

final class EpisodesListViewModel: ObservableObject {
    @Published private(set) var state = EpisodesListContainerViewState.idle

    func load() {
        switch state {
        case .idle, .failure:
            break
        default:
            return
        }
        episodePaginationService.reload()
    }

    private var episodePaginationService: AnyPaginationService<EpisodeDTO>
    private var bag = Set<AnyCancellable>()

    init(episodePaginationService: AnyPaginationService<EpisodeDTO>) {
        self.episodePaginationService = episodePaginationService
        self.episodePaginationService.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else {
                    return
                }
                switch state {
                case .idle:
                    self.state = .idle
                case .loadingFirstPage:
                    self.state = self.buildLoadingState([])
                case .loadingFurtherPage(let episodes):
                    self.state = self.buildLoadingState(episodes)
                case .loadedPartially(let episodes), .loadedFully(let episodes):
                    self.state = self.buildLoadedState(episodes)
                case .failure(let error):
                    self.state = self.buildFailureState(error)
                }
            }
            .store(in: &bag)
    }

    convenience init() {
        self.init(episodePaginationService: ServiceFactory.episodePaginationService)
    }

    private func buildLoadingState(_ episodes: [EpisodeDTO]) -> EpisodesListContainerViewState {
        .loading(.init(episodes: buildEpisodes(episodes), loadNext: loadNext))
    }

    private func buildLoadedState(_ episodes: [EpisodeDTO]) -> EpisodesListContainerViewState {
        .loaded(.init(episodes: buildEpisodes(episodes), loadNext: loadNext))
    }

    private func buildFailureState(_ error: DomainError) -> EpisodesListContainerViewState {
        .failure(
            .init(message: error.localizedDescription) { [weak self] in
                self?.load()
            }
        )
    }

    private func buildEpisodes(_ episodes: [EpisodeDTO]) -> [EpisodesListRowViewModel] {
        let formatted = { $0 > 9 ? String($0) : "0\($0)" }
        return episodes.map { episode in
            .init(
                id: episode.id,
                season: episode.season,
                title: "S\(formatted(episode.season)) E\(formatted(episode.number))"
            )
        }
    }

    private func loadNext() {
        if case .loaded = state {
            episodePaginationService.load()
        }
    }
}
