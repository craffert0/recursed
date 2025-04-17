// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct CurrentView: View {
    @Environment(RecurseService.self) private var service

    private let columns = [
        GridItem(.adaptive(minimum: 80)),
    ]

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(service.currentRecursers) { person in
                        NavigationLink {
                            PersonView(person: person)
                        } label: {
                            GridPersonView(person: person)
                        }
                    }
                }
            }
            .navigationTitle("Current Recursers")
            .navigationBarTitleDisplayMode(.large)
        }
        .task { try? await service.fetchCurrent() }
    }
}
