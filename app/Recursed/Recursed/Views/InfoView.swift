// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct InfoView: View {
    @Environment(RecurseService.self) var service
    @State private var prefs = PreferencesModel.global

    var body: some View {
        NavigationView {
            VStack {
                Button("Logout") {
                    service.logout()
                }.buttonStyle(.bordered)

                NavigationLink {
                    LicenseView(model: LicenseModel())
                } label: {
                    Text("License").font(.largeTitle)
                }
            }
            .navigationTitle("Info")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    InfoView()
        .environment(RecurseService())
}
