// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct MainView: View {
    @Environment(RecurseService.self) var service
    @Environment(LocationService.self) var location

    var body: some View {
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
    }
}

#Preview {
    MainView()
        .environment(RecurseService())
        .environment(LocationService())
}
