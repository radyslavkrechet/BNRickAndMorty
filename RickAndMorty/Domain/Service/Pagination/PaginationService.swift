// Copyright © Radyslav Krechet. All rights reserved.

import Combine
import Foundation

final class PaginationService<DTO>: PaginationServiceType {
    var statePublisher: Published<PaginationServiceState<DTO>>.Publisher {
        $state
    }

    func load() {
        var previouslyLoaded = [DTO]()
        switch state {
        case .idle, .failure:
            break
        case .loadingFirstPage, .loadingFurtherPage, .loadedFully:
            return
        case .loadedPartially(let value):
            previouslyLoaded = value
        }
        state = page == 1 ? .loadingFirstPage : .loadingFurtherPage(previouslyLoaded)
        publisher(page)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.state = .failure(error)
                    } else {
                        self?.page += 1
                    }
                },
                receiveValue: { [weak self] value in
                    self?.state = value.count < 20
                        ? .loadedFully(previouslyLoaded + value)
                        : .loadedPartially(previouslyLoaded + value)
                }
            )
            .store(in: &bag)
    }

    func reload() {
        page = 1
        load()
    }

    @Published private var state = PaginationServiceState<DTO>.idle
    private let publisher: (Int) -> AnyPublisher<[DTO], DomainError>
    private var bag = Set<AnyCancellable>()
    private var page = 1

    init(publisher: @escaping (Int) -> AnyPublisher<[DTO], DomainError>) {
        self.publisher = publisher
    }
}
