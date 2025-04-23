// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Observation

@Observable
class BotControl {
    var name: String
    var alertMessage: String = ""
    var showAlert: Bool = false
    var buzzing: Bool = false

    init(name: String) {
        self.name = name
    }

    func run(action: @escaping () async throws -> String) {
        buzzing = true
        Task {
            var message = ""
            do {
                message = try await action()
            } catch {
                message = "\(error)"
            }
            Task { @MainActor in
                alertMessage = message
                showAlert = true
                buzzing = false
            }
        }
    }
}
