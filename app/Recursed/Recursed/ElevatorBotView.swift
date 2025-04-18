// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct ElevatorBotView: View {
    @State private var service = RecurseService.global
    @State var control = BotControl(name: "ElevatorBot")

    var body: some View {
        BotView(control: control) {
            Text(try! AttributedString(
                markdown:
                "1\\. Press both *up* and *down* buttons in the lobby" +
                    " to summon both elevators."
            ))
            Text(
                "2. Send the elevator on the right side to the basement" +
                    " and step out before the doors close."
            )
            Text(
                "3. While that elevator is traveling, get into" +
                    " the left elevator.")
            HStack {
                Text("4. Tap")
                BotButtonView("Beam Me Up!", control: control) {
                    try await service.elevatorBuzz()
                }
            }
            Text("5. ElevatorBot will summon your elevator to" +
                " the 4th floor.")
        }
    }
}

#Preview {
    NavigationView {
        ElevatorBotView()
    }
}
