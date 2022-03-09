// Copyright © Radyslav Krechet. All rights reserved.

import Combine
import Foundation

final class CharactersCollectionViewModel: ObservableObject {
    @Published private(set) var state = CharactersCollectionContainerViewState.idle

    func load() {
        switch state {
        case .idle, .failure:
            break
        default:
            return
        }
        state = .loading
        characterService.getCharactersCollection()
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

    private var characterService: CharacterServiceType
    private var bag = Set<AnyCancellable>()

    init(characterService: CharacterServiceType) {
        self.characterService = characterService
    }

    convenience init() {
        self.init(characterService: ServiceFactory.characterService)
    }

    private func buildLoadedState(
        _ charactersCollection: CharactersCollectionDTO
    ) -> CharactersCollectionContainerViewState {
        var collections = [CharactersCollectionRowViewModel]()
        collections.append(
            .init(id: "featured", kind: .featured, characters: charactersCollection.featured.map { character in
                .init(
                    id: character.id,
                    image: .init(url: character.imageURL, context: .charactersFeaturedCollection),
                    title: character.name
                )
            })
        )
        Gender.allCases.forEach { gender in
            let characters = charactersCollection.gender[gender]?.map { character in
                CharactersCollectionItemViewModel(
                    id: character.id,
                    image: .init(url: character.imageURL, context: .charactersGenderCollection),
                    title: character.name
                )
            }
            if let characters = characters {
                collections.append(.init(id: gender.rawValue, kind: .gender(gender), characters: characters))
            }
        }
        return .loaded(.init(collections: collections))
    }

    private func buildFailureState(_ error: DomainError) -> CharactersCollectionContainerViewState {
        .failure(
            .init(message: error.localizedDescription) { [weak self] in
                self?.load()
            }
        )
    }
}
