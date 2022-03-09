// Copyright © Radyslav Krechet. All rights reserved.

import Foundation

struct EpisodeResponse: Decodable {
    let id: Int
    let name: String
    let airDate: Date
    let episode: String
    let characters: [URL]
}
