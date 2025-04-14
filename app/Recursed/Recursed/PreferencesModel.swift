// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Combine
import SwiftUI

class PreferencesModel: ObservableObject {
    static let global = PreferencesModel()

    @AppStorage("settings.emailAddress") var emailAddress: String = ""
    public var error: KeychainError? = nil
    public var authorizationToken: String? {
        get {
            actualAuthorizationToken
        }
        set {
            if let newValue {
                set(token: newValue)
            } else if actualAuthorizationToken != nil {
                actualAuthorizationToken = nil
                clearToken()
            }
        }
    }

    private var actualAuthorizationToken = PreferencesModel.loadToken()
    // 775731b98c0625717542f9df52a70b94d4069b0861572ab05d68d1ed9bddac2b

    private static let kRecurseServer = "www.recurse.com"

    private static func loadToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: PreferencesModel.kRecurseServer,
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

    private func set(token: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: PreferencesModel.kRecurseServer,
            kSecValueData as String: Data(token.utf8),
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            actualAuthorizationToken = token
            error = nil
        } else {
            actualAuthorizationToken = nil
            error = KeychainError.unhandledError(status: status)
        }
    }

    private func clearToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: PreferencesModel.kRecurseServer,
        ]
        let status = SecItemDelete(query as CFDictionary)
        switch status {
        case errSecSuccess, errSecItemNotFound:
            error = KeychainError.unhandledError(status: status)
        default:
            break
        }
    }
}
