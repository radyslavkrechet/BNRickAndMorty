// Copyright © Radyslav Krechet. All rights reserved.

enum NetworkError: Error {
    case badRequest
    case badResponse
    case decodingFailure
    case connectionFailure
    case unknown
}
