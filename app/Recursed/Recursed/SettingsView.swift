// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct SettingsView: View {
    @State private var service = RecurseService.global
    @State private var prefs = PreferencesModel.global

    var body: some View {
        NavigationView {
            VStack {
                Button("Logout") {
                    service.logout()
                }.buttonStyle(.bordered)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    SettingsView()
}
