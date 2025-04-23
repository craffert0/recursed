// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

enum KeychainError: Error {
    case noAuthorizationToken
    case unexpectedAuthorizationTokenData
    case unhandledError(status: OSStatus)
    case unknown(error: Error)

    static func from(error: Error) -> KeychainError {
        if let result = error as? KeychainError {
            return result
        }
        return .unknown(error: error)
    }
}
