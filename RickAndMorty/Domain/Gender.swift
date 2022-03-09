// Copyright © Radyslav Krechet. All rights reserved.

import Foundation

enum Gender: String, CaseIterable {
    case female
    case male
    case genderless
    case unknown

    var title: String {
        switch self {
        case .female:
            return NSLocalizedString("gender_female", comment: "")
        case .male:
            return NSLocalizedString("gender_male", comment: "")
        case .genderless:
            return NSLocalizedString("gender_genderless", comment: "")
        case .unknown:
            return NSLocalizedString("gender_unknown", comment: "")
        }
    }
}
