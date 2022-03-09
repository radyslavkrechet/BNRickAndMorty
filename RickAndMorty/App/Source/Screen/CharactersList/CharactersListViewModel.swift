// Copyright © Radyslav Krechet. All rights reserved.

import Combine
import Foundation

final class CharactersListViewModel: ObservableObject {
    @Published private(set) var state = CharactersListContainerViewState.idle

    var navigationTitle: String {
        gender.title
    }

    func load() {
        switch state {
        case .idle, .failure:
            break
        default:
            return
        }
        characterPaginationService.reload()
    }

    private let gender: Gender
    private var characterPaginationService: AnyPaginationService<CharacterDTO>
    private var bag = Set<AnyCancellable>()

    init(gender: Gender, characterPaginationService: AnyPaginationService<CharacterDTO>) {
        self.gender = gender
        self.characterPaginationService = characterPaginationService
        self.characterPaginationService.statePublisher
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
                case .loadingFurtherPage(let characters):
                    self.state = self.buildLoadingState(characters)
                case .loadedPartially(let characters), .loadedFully(let characters):
                    self.state = self.buildLoadedState(characters)
                case .failure(let error):
                    self.state = self.buildFailureState(error)
                }
            }
            .store(in: &bag)
    }

    convenience init(gender: Gender) {
        self.init(gender: gender, characterPaginationService: ServiceFactory.characterPaginationService(gender: gender))
    }

    private func buildLoadingState(_ characters: [CharacterDTO]) -> CharactersListContainerViewState {
        .loading(.init(characters: buildCharacters(characters), loadNext: loadNext))
    }

    private func buildLoadedState(_ characters: [CharacterDTO]) -> CharactersListContainerViewState {
        .loaded(.init(characters: buildCharacters(characters), loadNext: loadNext))
    }

    private func buildFailureState(_ error: DomainError) -> CharactersListContainerViewState {
        .failure(
            .init(message: error.localizedDescription) { [weak self] in
                self?.load()
            }
        )
    }

    private func buildCharacters(_ characters: [CharacterDTO]) -> [CharacterRowViewModel] {
        characters.map { .init(id: $0.id, imageURL: $0.imageURL, title: $0.name) }
    }

    private func loadNext() {
        if case .loaded = state {
            characterPaginationService.load()
        }
    }
}
