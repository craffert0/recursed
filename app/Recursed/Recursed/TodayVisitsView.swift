// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import SwiftUI

struct TodayVisitsView: View {
    @Environment(RecurseService.self) private var service

    @State var showsError: Bool = false
    @State var error: RecurseServiceError?

    let columns = [
        GridItem(.adaptive(minimum: 80)),
    ]

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                if let me = service.me,
                   !service.currentVisitors.contains(where: { $0.id == me.id })
                {
                    Button("Check in?") {
                        checkin()
                    }.buttonStyle(.bordered)
                }
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(service.currentVisitors) { person in
                        NavigationLink {
                            PersonView(person: person)
                        } label: {
                            GridPersonView(person: person)
                        }
                    }
                }
            }
            .navigationTitle("At The Hub")
            .navigationBarTitleDisplayMode(.large)
        }
        .alert(isPresented: $showsError, error: error) {}
        .refreshable { await refresh() }
        .task { await refresh() }
    }

    private func refresh() async {
        do {
            try await service.fetchVisitors()
            try await service.loadMe()
        } catch {
            self.error = error as? RecurseServiceError ?? .otherError(error)
            showsError = true
        }
    }

    private func checkin() {
        Task {
            do {
                try await service.checkin()
                try await service.fetchVisitors()
            } catch {
                self.error = error as? RecurseServiceError ?? .otherError(error)
                showsError = true
            }
        }
    }
}
