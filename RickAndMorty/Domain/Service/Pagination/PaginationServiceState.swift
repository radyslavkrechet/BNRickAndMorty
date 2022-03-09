// Copyright © Radyslav Krechet. All rights reserved.

enum PaginationServiceState<DTO> {
    case idle
    case loadingFirstPage
    case loadingFurtherPage([DTO])
    case loadedPartially([DTO])
    case loadedFully([DTO])
    case failure(DomainError)
}
