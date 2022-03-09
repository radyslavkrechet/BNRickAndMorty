// Copyright © Radyslav Krechet. All rights reserved.

import Combine

protocol PaginationServiceType: AnyObject {
    associatedtype DTO

    var statePublisher: Published<PaginationServiceState<DTO>>.Publisher { get }

    func load()
    func reload()
}

extension PaginationServiceType {
    func eraseToAnyPaginationService() -> AnyPaginationService<DTO> {
        AnyPaginationService(self)
    }
}
