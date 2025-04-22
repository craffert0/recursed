// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct BatchView: View {
    @State private var service = RecurseService.global

    let batch: RecurseStint.Batch

    var body: some View {
        NavigationView {
            VStack {
                PeopleGridView(people: service.searchResults)
            }
            .navigationTitle(batch.name)
            .navigationBarTitleDisplayMode(.large)
        }
        .task { try? await service.search(batchId: batch.id) }
    }
}
