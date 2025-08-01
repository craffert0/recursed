// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Combine
import SwiftUI

class PreferencesModel: ObservableObject {
    static let global = PreferencesModel()

    @AppStorage("settings.emailAddress") var emailAddress: String = ""
    @AppStorage("settings.userId") var userId: Int?
    @Published var error: KeychainError? = nil
    @Published var debugMode: Bool = false
    private var actualToken = AuthorizationToken()
    var authorizationToken: String? {
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
