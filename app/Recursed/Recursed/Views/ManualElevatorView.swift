// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct ManualElevatorView: View {
    @State var control = BotControl(name: "ManualElevator")
    @State var isElevatorBotPresented: Bool = false

    var body: some View {
        BotView(control: control) {
            Text("1. Since it is currently a weekday during the day," +
                " the elevator to the 5th floor is unlocked.")
            Text(try! AttributedString(
                markdown:
                "2\\. Press the *up* button in the lobby" +
                    " to summon an elevator."
            ))
            Text(try! AttributedString(
                markdown:
                "3\\. Enter the elevator and press the button marked *5*."
            ))
            Text("4. ManualElevator will whisk you to the 5th floor.")
            Text("5. To get to the 4th floor, borrow a" +
                " yardstick-fob to use the stairs or elevator.")
            HStack {
                Text("Alternatively,")
                Button("ElevatorBot") {
                    isElevatorBotPresented = true
                }
                .sheet(isPresented: $isElevatorBotPresented) {
                    ElevatorBotView()
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

#Preview {
    NavigationView {
        ManualElevatorView()
    }
}
