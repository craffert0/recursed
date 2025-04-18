// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import SwiftUI

struct TodayVisitsView: View {
    @State private var service = RecurseService.global
    @State var showsError: Bool = false
    @State var error: RecurseServiceError?

    var body: some View {
        NavigationView {
            VStack {
                if let me = service.me,
                   !service.currentVisitors.contains(where: { $0.id == me.id })
                {
                    Button("Check in?") {
                        checkin()
                    }.buttonStyle(.bordered)
                }
                PeopleGridView(people: service.currentVisitors)
            }
            .navigationTitle("At The Hub")
            .navigationBarTitleDisplayMode(.large)
        }
        .alert(isPresented: $showsError, error: error) {}
        .refreshable { await refresh() }
        .task { await refresh() }
    }

    private func refresh() async {
        try? await service.fetchVisitors()
        try? await service.loadMe()
    }

    private func checkin() {
        Task {
            do {
                try await service.checkin()
                try? await service.fetchVisitors()
            } catch {
                self.error = error as? RecurseServiceError ?? .otherError(error)
                showsError = true
            }
        }
    }
}
