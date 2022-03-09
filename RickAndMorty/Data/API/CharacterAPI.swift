// Copyright © Radyslav Krechet. All rights reserved.

import Combine

protocol CharacterAPIType {
    func getCharacters(ids: [Int]) -> AnyPublisher<[CharacterResponse], NetworkError>
    func getCharacters(gender: String, page: Int) -> AnyPublisher<PageResponse<CharacterResponse>, NetworkError>
    func getCharacter(id: Int) -> AnyPublisher<CharacterResponse, NetworkError>
}

struct CharacterAPI: CharacterAPIType {
    func getCharacters(ids: [Int]) -> AnyPublisher<[CharacterResponse], NetworkError> {
        let pathComponent = ids.map(String.init).joined(separator: ",")
        let request = NetworkRequest(method: .GET, path: "/api/character/\(pathComponent)")
        return networkService.execute(request)
    }

    func getCharacters(gender: String, page: Int) -> AnyPublisher<PageResponse<CharacterResponse>, NetworkError> {
        let request = NetworkRequest(
            method: .GET,
            path: "/api/character/",
            query: ["gender": gender, "page": String(page)]
        )
        return networkService.execute(request)
    }

    func getCharacter(id: Int) -> AnyPublisher<CharacterResponse, NetworkError> {
        let request = NetworkRequest(method: .GET, path: "/api/character/\(id)")
        return networkService.execute(request)
    }

    private let networkService: NetworkServiceType

    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
}
