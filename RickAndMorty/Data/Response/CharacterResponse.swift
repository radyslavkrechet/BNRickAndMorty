// Copyright © Radyslav Krechet. All rights reserved.

import Foundation

struct CharacterResponse: Decodable {
    struct Location: Decodable {
        let name: String
    }

    let id: Int
    let name: String
    let status: String
    let species: String
    let origin: Location
    let location: Location
    let image: URL
}
