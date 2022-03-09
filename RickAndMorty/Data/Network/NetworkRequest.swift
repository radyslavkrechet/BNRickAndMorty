// Copyright © Radyslav Krechet. All rights reserved.

import Foundation

struct NetworkRequest {
    enum Method: String {
        case GET
        case POST
        case PUT
        case PATCH
        case DELETE
    }

    let method: Method
    let path: String
    let query: [String: String]
    let body: Data?

    init(method: Method, path: String, query: [String: String] = [:], body: Data? = nil) {
        self.method = method
        self.path = path
        self.query = query
        self.body = body
    }
}
