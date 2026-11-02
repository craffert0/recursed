// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct StairwellBotView: View {
    @Environment(RecurseService.self) var service
    @State var control = BotControl(name: "StairwellBot")

    var body: some View {
        BotView(control: control) {
            Text("1. Climb to the 4th floor.")
            HStack {
                Text("2. Tap")
                BotButtonView("Open Says Me!", control: control) {
                    try await service.stairwellBuzz()
                }
            }
            Text("3. Push the door open.")
            Text("4. Welcome!")
        }
    }
}

#Preview("unknown") {
    StairwellBotView()
        .environment(RecurseService(doorbotStatus: .unknown))
}

#Preview("good") {
    StairwellBotView()
        .environment(RecurseService(doorbotStatus: .good))
}

#Preview("bad") {
    StairwellBotView()
        .environment(RecurseService(doorbotStatus: .bad("some problem")))
}
