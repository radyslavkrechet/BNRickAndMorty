// Copyright © Radyslav Krechet. All rights reserved.

import Combine

final class AnyPaginationService<DTO>: PaginationServiceType {
    var statePublisher: Published<PaginationServiceState<DTO>>.Publisher {
        statePublisherValue
    }

    func load() {
        loadClosure()
    }

    func reload() {
        reloadClosure()
    }

    private let statePublisherValue: Published<PaginationServiceState<DTO>>.Publisher
    private let loadClosure: () -> Void
    private let reloadClosure: () -> Void

    init<PaginationService: PaginationServiceType>(
        _ paginationService: PaginationService
    ) where PaginationService.DTO == DTO {
        statePublisherValue = paginationService.statePublisher
        loadClosure = paginationService.load
        reloadClosure = paginationService.reload
    }
}
