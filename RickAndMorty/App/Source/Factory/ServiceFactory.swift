// Copyright © Radyslav Krechet. All rights reserved.

enum ServiceFactory {
    static var characterService: CharacterServiceType {
        CharacterService(characterAPI: APIFactory.characterAPI)
    }

    static var episodeService: EpisodeServiceType {
        EpisodeService(episodeAPI: APIFactory.episodeAPI, characterAPI: APIFactory.characterAPI)
    }

    static var episodePaginationService: AnyPaginationService<EpisodeDTO> {
        PaginationService<EpisodeDTO> { page in
            episodeService.getEpisodes(page: page)
        }
        .eraseToAnyPaginationService()
    }

    static func characterPaginationService(gender: Gender) -> AnyPaginationService<CharacterDTO> {
        PaginationService<CharacterDTO> { page in
            characterService.getCharacters(gender: gender, page: page)
        }
        .eraseToAnyPaginationService()
    }
}
