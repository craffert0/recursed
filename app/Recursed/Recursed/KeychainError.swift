// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

enum KeychainError: Error {
    case noAuthorizationToken
    case unexpectedAuthorizationTokenData
    case unhandledError(status: OSStatus)
}
