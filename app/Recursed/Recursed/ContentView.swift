// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var service = RecurseService.global
    @State private var location = LocationService.global

    var body: some View {
        if case .loggedIn = service.status {
            TabView {
                if location.nearRecurse397 {
                    Tab("Tools", systemImage: "wrench.and.screwdriver") {
                        ToolsView()
                    }
                }

                Tab("Search", systemImage: "magnifyingglass.circle.fill") {
                    SearchView()
                }

                Tab("Hub", systemImage: "house.circle.fill") {
                    TodayVisitsView()
                }

                Tab("Current", systemImage: "person.circle.fill") {
                    CurrentView()
                }

                Tab("Settings", systemImage: "gearshape") {
                    SettingsView()
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
