// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

enum RecurseServiceError: Error {
    case cannotEncode
    case httpError(Int)
    case otherError(Error)
}

extension RecurseServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cannotEncode: "cannot encode"
        case let .httpError(code): "http error: \(code)"
        case let .otherError(error): "error \(error)"
        }
    }
}
