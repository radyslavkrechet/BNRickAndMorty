// Copyright © Radyslav Krechet. All rights reserved.

import Combine

protocol EpisodeServiceType {
    func getEpisodes(page: Int) -> AnyPublisher<[EpisodeDTO], DomainError>
    func getEpisode(id: Int) -> AnyPublisher<EpisodeDTO, DomainError>
}

struct EpisodeService: EpisodeServiceType {
    func getEpisodes(page: Int) -> AnyPublisher<[EpisodeDTO], DomainError> {
        episodeAPI.getEpisodes(page: page)
            .map { $0.results.map { .init(episode: $0) } }
            .mapError(DomainError.init)
            .eraseToAnyPublisher()
    }

    func getEpisode(id: Int) -> AnyPublisher<EpisodeDTO, DomainError> {
        episodeAPI.getEpisode(id: id)
            .flatMap { [characterAPI] episode -> AnyPublisher<EpisodeDTO, NetworkError> in
                let characterIds = episode.characters.map(\.lastPathComponent)
                let someAppearedCharacterIds = characterIds.shuffled().prefix(5).compactMap(Int.init)
                return characterAPI.getCharacters(ids: someAppearedCharacterIds)
                    .map { .init(episode: episode, someAppearedCharacters: $0) }
                    .eraseToAnyPublisher()
            }
            .mapError(DomainError.init)
            .eraseToAnyPublisher()
    }

    private let episodeAPI: EpisodeAPIType
    private let characterAPI: CharacterAPIType

    init(episodeAPI: EpisodeAPIType, characterAPI: CharacterAPIType) {
        self.episodeAPI = episodeAPI
        self.characterAPI = characterAPI
    }
}
