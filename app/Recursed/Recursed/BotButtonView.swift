// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct BotButtonView: View {
    let text: String
    @State var control: BotControl
    var action: () async throws -> String

    init(_ text: String,
         control: BotControl,
         action: @escaping () async throws -> String)
    {
        self.text = text
        self.control = control
        self.action = action
    }

    var body: some View {
        Button(text) {
            control.run { try await action() }
        }
        .disabled(control.buzzing)
        .buttonStyle(.bordered)
    }
}
