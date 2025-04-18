// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(RecurseService.self) private var service

    var body: some View {
        if case .loggedIn = service.status {
            TabView {
                Tab("Hub", systemImage: "house.circle.fill") {
                    TodayVisitsView()
                }

                Tab("Current", systemImage: "person.circle.fill") {
                    CurrentView()
                }

                Tab("Settings", systemImage: "gearshape") {
                    Button("Logout") {
                        service.logout()
                    }.buttonStyle(.bordered)
                }
            }
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
