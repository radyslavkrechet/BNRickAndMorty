// Copyright © Radyslav Krechet. All rights reserved.

import Foundation

struct EpisodeDTO {
    let id: Int
    let season: Int
    let number: Int
    let name: String
    let airDate: Date
    let someAppearedCharacters: [CharacterDTO]

    private static let digit: (Substring?) -> Int = { substring in
        guard let substring = substring else {
            return 0
        }
        return Int(substring) ?? 0
    }

    init(episode: EpisodeResponse, someAppearedCharacters: [CharacterResponse] = []) {
        id = episode.id
        let episodeComponents = episode.episode.dropFirst().split(separator: "E")
        season = Self.digit(episodeComponents.first)
        number = Self.digit(episodeComponents.last)
        name = episode.name
        airDate = episode.airDate
        self.someAppearedCharacters = someAppearedCharacters.map(CharacterDTO.init)
    }
}
