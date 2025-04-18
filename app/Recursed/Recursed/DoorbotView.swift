// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct DoorbotView: View {
    @State private var service = RecurseService.global
    @State var control = BotControl(name: "Doorbot")

    var body: some View {
        BotView(control: control) {
            Text("1. Approach the building entrance.")
            Text("2. Using the arrows on the intercom, call the" +
                " 4th floor. This will ring the intercom" +
                " inside RC.")
            HStack {
                Text("3. Tap")
                BotButtonView("Buzz Me In!", control: control) {
                    try await service.doorbotBuzz()
                }
            }
            Text("4. Walk into the building.")
        }
    }
}

#Preview {
    NavigationView {
        DoorbotView()
    }
}
