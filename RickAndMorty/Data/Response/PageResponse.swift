// Copyright © Radyslav Krechet. All rights reserved.

struct PageResponse<Item: Decodable>: Decodable {
    let results: [Item]
}
