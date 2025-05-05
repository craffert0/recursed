// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import SwiftUI

struct TodayVisitsView: View {
    @State var service: RecurseService
    @Environment(LocationService.self) var location
    @State private var preferences = PreferencesModel.global
    @State var showsError: Bool = false
    @State var error: RecurseServiceError?

    var body: some View {
        NavigationStack {
            VStack {
                if location.nearRecurse397,
                   let userId = preferences.userId,
                   !service.currentVisitors.contains(
                       where: { $0.id == userId })
                {
                    Button("Check in?") {
                        checkin()
                    }.buttonStyle(.bordered)
                }
                PeopleGridView(people: $service.currentVisitors)
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
                self.error = RecurseServiceError.from(error: error)
                showsError = true
            }
        }
    }
}

#Preview {
    TodayVisitsView(service: {
        let service = RecurseService()
        service.currentVisitors = [RecursePerson].fakePeople
            .sorted { a, b in a.name < b.name }
        return service
    }())
        .environment(LocationService())
}
