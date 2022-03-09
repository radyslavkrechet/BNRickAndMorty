// Copyright © Radyslav Krechet. All rights reserved.

import Combine
import Foundation

final class CharacterDetailsViewModel: ObservableObject {
    @Published private(set) var state = CharacterDetailsContainerViewState.idle

    func load() {
        switch state {
        case .idle, .failure:
            break
        default:
            return
        }
        state = .loading
        characterService.getCharacter(id: id)
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
    private var characterService: CharacterServiceType
    private var bag = Set<AnyCancellable>()

    init(id: Int, characterService: CharacterServiceType) {
        self.id = id
        self.characterService = characterService
    }

    convenience init(id: Int) {
        self.init(id: id, characterService: ServiceFactory.characterService)
    }

    private func buildLoadedState(_ character: CharacterDTO) -> CharacterDetailsContainerViewState {
        var items = [CharacterDetailsItemViewModel]()
        let status: () -> String? = {
            switch character.status {
            case .alive:
                return NSLocalizedString("character_details_text_alive", comment: "")
            case .dead:
                return NSLocalizedString("character_details_text_dead", comment: "")
            case .unknown:
                return nil
            }
        }
        if let status = status() {
            items.append(
                .init(title: NSLocalizedString("character_details_text_status", comment: ""), body: status)
            )
        }
        if let species = character.species {
            items.append(
                .init(title: NSLocalizedString("character_details_text_species", comment: ""), body: species)
            )
        }
        if let home = character.home {
            items.append(
                .init(title: NSLocalizedString("character_details_text_home", comment: ""), body: home)
            )
        }
        if let lastAppearancePlace = character.lastAppearancePlace {
            items.append(
                .init(title: NSLocalizedString("character_details_text_place", comment: ""), body: lastAppearancePlace)
            )
        }
        return .loaded(.init(header: .init(imageURL: character.imageURL, title: character.name), items: items))
    }

    private func buildFailureState(_ error: DomainError) -> CharacterDetailsContainerViewState {
        .failure(
            .init(message: error.localizedDescription) { [weak self] in
                self?.load()
            }
        )
    }
}
