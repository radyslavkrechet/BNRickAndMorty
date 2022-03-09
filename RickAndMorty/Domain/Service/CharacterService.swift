// Copyright © Radyslav Krechet. All rights reserved.

import Combine

protocol CharacterServiceType {
    func getCharactersCollection() -> AnyPublisher<CharactersCollectionDTO, DomainError>
    func getCharacters(gender: Gender, page: Int) -> AnyPublisher<[CharacterDTO], DomainError>
    func getCharacter(id: Int) -> AnyPublisher<CharacterDTO, DomainError>
}

struct CharacterService: CharacterServiceType {
    func getCharactersCollection() -> AnyPublisher<CharactersCollectionDTO, DomainError> {
        characterAPI.getCharacters(ids: [1, 2])
            .zip(
                Publishers.Zip4(
                    characterAPI.getCharacters(gender: Gender.female.rawValue, page: 1),
                    characterAPI.getCharacters(gender: Gender.male.rawValue, page: 1),
                    characterAPI.getCharacters(gender: Gender.genderless.rawValue, page: 1),
                    characterAPI.getCharacters(gender: Gender.unknown.rawValue, page: 1)
                )
            )
            .map { characters in
                CharactersCollectionDTO(
                    featured: characters.0.map(CharacterDTO.init),
                    gender: [
                        .female: characters.1.0.results.prefix(5).map(CharacterDTO.init),
                        .male: characters.1.1.results.dropFirst(2).prefix(5).map(CharacterDTO.init),
                        .genderless: characters.1.2.results.prefix(5).map(CharacterDTO.init),
                        .unknown: characters.1.3.results.prefix(5).map(CharacterDTO.init)
                    ]
                )
            }
            .mapError(DomainError.init)
            .eraseToAnyPublisher()
    }

    func getCharacters(gender: Gender, page: Int) -> AnyPublisher<[CharacterDTO], DomainError> {
        characterAPI.getCharacters(gender: gender.rawValue, page: page)
            .map { $0.results.map(CharacterDTO.init) }
            .mapError(DomainError.init)
            .eraseToAnyPublisher()
    }

    func getCharacter(id: Int) -> AnyPublisher<CharacterDTO, DomainError> {
        characterAPI.getCharacter(id: id)
            .map(CharacterDTO.init)
            .mapError(DomainError.init)
            .eraseToAnyPublisher()
    }

    private let characterAPI: CharacterAPIType

    init(characterAPI: CharacterAPIType) {
        self.characterAPI = characterAPI
    }
}
