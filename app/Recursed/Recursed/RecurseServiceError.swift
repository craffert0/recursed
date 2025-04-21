// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

enum RecurseServiceError: Error {
    case cannotEncode
    case httpError(Int)
    case otherError(Error)
    case loggedOut

    static func from(error: Error) -> RecurseServiceError {
        if let result = error as? RecurseServiceError {
            return result
        }
        return .otherError(error)
    }
}

extension RecurseServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cannotEncode: "cannot encode"
        case let .httpError(code): "http error: \(code)"
        case let .otherError(error): "error \(error)"
        case .loggedOut: "must login"
        }
    }
}
