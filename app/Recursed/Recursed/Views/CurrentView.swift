// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct CurrentView: View {
    @Environment(RecurseService.self) var service

    var body: some View {
        NavigationView {
            VStack {
                PeopleGridView(people: service.currentRecursers)
            }
            .navigationTitle("Current Recursers")
            .navigationBarTitleDisplayMode(.large)
        }
        .task { try? await service.fetchCurrent() }
    }
}
