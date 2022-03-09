// Copyright © Radyslav Krechet. All rights reserved.

import Combine

protocol EpisodeAPIType {
    func getEpisodes(page: Int) -> AnyPublisher<PageResponse<EpisodeResponse>, NetworkError>
    func getEpisode(id: Int) -> AnyPublisher<EpisodeResponse, NetworkError>
}

struct EpisodeAPI: EpisodeAPIType {
    func getEpisodes(page: Int) -> AnyPublisher<PageResponse<EpisodeResponse>, NetworkError> {
        let request = NetworkRequest(method: .GET, path: "/api/episode", query: ["page": String(page)])
        return networkService.execute(request)
    }

    func getEpisode(id: Int) -> AnyPublisher<EpisodeResponse, NetworkError> {
        let request = NetworkRequest(method: .GET, path: "/api/episode/\(id)")
        return networkService.execute(request)
    }

    private let networkService: NetworkServiceType

    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
}
