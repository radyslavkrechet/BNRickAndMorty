// Copyright © Radyslav Krechet. All rights reserved.

import Foundation

enum DomainError: LocalizedError {
    case connectionFailure
    case fetchingFailure

    var errorDescription: String? {
        switch self {
        case .connectionFailure:
            return NSLocalizedString("error_connection_failure_message", comment: "")
        case .fetchingFailure:
            return NSLocalizedString("error_fetching_failure_message", comment: "")
        }
    }

    init(error: NetworkError) {
        switch error {
        case .connectionFailure:
            self = .connectionFailure
        default:
            self = .fetchingFailure
        }
    }
}
