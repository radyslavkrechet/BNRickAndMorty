// Copyright © Radyslav Krechet. All rights reserved.

import Combine
import Foundation

protocol NetworkServiceType {
    func execute<NetworkResponse: Decodable>(_ request: NetworkRequest) -> AnyPublisher<NetworkResponse, NetworkError>
}

struct NetworkService: NetworkServiceType {
    func execute<NetworkResponse: Decodable>(_ request: NetworkRequest) -> AnyPublisher<NetworkResponse, NetworkError> {
        var urlComponents = URLComponents()
        urlComponents.path = request.path
        urlComponents.queryItems = request.query.map { .init(name: $0.key, value: $0.value) }
        guard let url = urlComponents.url(relativeTo: baseURL) else {
            return Fail<NetworkResponse, NetworkError>(error: NetworkError.badRequest).eraseToAnyPublisher()
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        return urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200 ..< 400 ~= httpResponse.statusCode else {
                    throw NetworkError.badResponse
                }
                return data
            }
            .decode(type: NetworkResponse.self, decoder: jsonDecoder)
            .mapError { error in
                switch error {
                case let networkError as NetworkError:
                    return networkError
                case is DecodingError:
                    return NetworkError.decodingFailure
                case URLError.timedOut, URLError.networkConnectionLost, URLError.notConnectedToInternet:
                    return NetworkError.connectionFailure
                default:
                    return NetworkError.unknown
                }
            }
            .eraseToAnyPublisher()
    }

    private let baseURL: URL
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder

    init(urlSession: URLSession = .shared, baseURL: URL, jsonDecoder: JSONDecoder) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
}
