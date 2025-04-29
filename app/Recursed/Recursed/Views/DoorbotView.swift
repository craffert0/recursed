// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct DoorbotView: View {
    @Environment(RecurseService.self) var service
    @State var control = BotControl(name: "Doorbot")

    var body: some View {
        BotView(control: control, problem: problem) {
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

    private var problem: String? {
        switch service.doorbotStatus {
        case .unknown: "Doorbot status unknown"
        case .good: nil
        case let .bad(reason): "Doorbot may be down: \(reason)"
        }
    }
}

#Preview {
    TabView {
        Tab("unknown", systemImage: "magnifyingglass.circle.fill") {
            DoorbotView()
                .environment({
                    let r = RecurseService()
                    r.doorbotStatus = .unknown
                    return r
                }())
        }
        Tab("good", systemImage: "magnifyingglass.circle.fill") {
            DoorbotView()
                .environment({
                    let r = RecurseService()
                    r.doorbotStatus = .good
                    return r
                }())
        }
        Tab("bad", systemImage: "magnifyingglass.circle.fill") {
            DoorbotView()
                .environment({
                    let r = RecurseService()
                    r.doorbotStatus = .bad("some problem")
                    return r
                }())
        }
    }
}
