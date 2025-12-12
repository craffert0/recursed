// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct MainView: View {
    @EnvironmentObject var service: RecurseService
    @EnvironmentObject var location: LocationService

    var body: some View {
        TabView {
            if location.nearRecurse397 {
                ToolsView()
                    .tabItem {
                        Label("Hub Tools", systemImage: "wrench.and.screwdriver")
                    }
            }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass.circle.fill")
                }

            TodayVisitsView(service: service)
                .tabItem {
                    Label("At The Hub", systemImage: "house.circle.fill")
                }

            SimpleSearchView(title: "Current Recursers",
                             searchArgs: ["scope": "current"])
                .tabItem {
                    Label("Current", systemImage: "person.circle.fill")
                }

            InfoView()
                .tabItem {
                    Label("Info", systemImage: "info.circle.fill")
                }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(RecurseService())
        .environmentObject(LocationService())
}
