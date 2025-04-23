// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Security

class AuthorizationToken {
    private(set) var value = AuthorizationToken.loadToken()

    private static let kRecurseServer = "www.recurse.com"

    func set(value: String?) throws {
        if let value {
            try setToken(token: value)
        } else {
            try clearToken()
        }
    }

    private static func loadToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: AuthorizationToken.kRecurseServer,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]

        // Get the item holding the credentials
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
              let actual = item as? [String: Any],
              let tokenData = actual[kSecValueData as String] as? Data,
              let token = String(data: tokenData, encoding: .utf8)
        else {
            return nil
        }
        return token
    }

    private func setToken(token: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: AuthorizationToken.kRecurseServer,
            kSecValueData as String: Data(token.utf8),
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            value = token
        } else {
            value = nil
            throw KeychainError.unhandledError(status: status)
        }
    }

    private func clearToken() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: AuthorizationToken.kRecurseServer,
        ]
        let status = SecItemDelete(query as CFDictionary)
        switch status {
        case errSecSuccess, errSecItemNotFound:
            break
        default:
            throw KeychainError.unhandledError(status: status)
        }
    }
}
