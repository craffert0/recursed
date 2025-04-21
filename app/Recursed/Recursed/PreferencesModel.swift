// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Combine
import SwiftUI

class PreferencesModel: ObservableObject {
    static let global = PreferencesModel()

    @AppStorage("settings.emailAddress") var emailAddress: String = ""
    @AppStorage("settings.userId") var userId: Int?
    public var error: KeychainError? = nil
    private var actualToken = AuthorizationToken()
    public var authorizationToken: String? {
        get {
            actualToken.value
        }
        set {
            do {
                try actualToken.set(value: newValue)
            } catch {
                self.error = KeychainError.from(error: error)
            }
        }
    }
}
