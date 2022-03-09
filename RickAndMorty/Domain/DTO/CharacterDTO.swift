// Copyright © Radyslav Krechet. All rights reserved.

import Foundation

struct CharacterDTO {
    enum Status {
        case alive
        case dead
        case unknown

        init(status: String) {
            switch status {
            case "Alive":
                self = .alive
            case "Dead":
                self = .dead
            default:
                self = .unknown
            }
        }
    }

    let id: Int
    let name: String
    let status: Status
    let species: String?
    let home: String?
    let lastAppearancePlace: String?
    let imageURL: URL

    private static let optional = { $0 == "unknown" ? nil : $0 }

    init(character: CharacterResponse) {
        id = character.id
        name = character.name
        status = .init(status: character.status)
        species = Self.optional(character.species)
        home = Self.optional(character.origin.name)
        lastAppearancePlace = Self.optional(character.location.name)
        imageURL = character.image
    }
}
