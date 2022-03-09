// Copyright © Radyslav Krechet. All rights reserved.

import Foundation

enum APIFactory {
    static var characterAPI: CharacterAPIType {
        CharacterAPI(networkService: networkService)
    }

    static var episodeAPI: EpisodeAPIType {
        EpisodeAPI(networkService: networkService)
    }

    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = .init(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .init(secondsFromGMT: 0)
        return dateFormatter
    }

    private static var jsonDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }

    private static var networkService: NetworkServiceType {
        guard let baseURL = URL(string: "https://rickandmortyapi.com") else {
            fatalError("Base URL is not valid")
        }
        return NetworkService(baseURL: baseURL, jsonDecoder: jsonDecoder)
    }
}
