// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import SwiftUI

struct TodayVisitsView: View {
    @State var me: RecursePerson?
    @State var visitors: [VisitToPerson] = []
    @State var showsError: Bool = false
    @State var error: RecurseServiceError?

    private let service = RecurseService.global

    let columns = [
        GridItem(.adaptive(minimum: 80)),
    ]

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                if let me,
                   !visitors.contains(where: { $0.id == me.id })
                {
                    Button("Check in?") {
                        checkin()
                    }.buttonStyle(.bordered)
                }
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(visitors) { visitor in
                        switch visitor.state {
                        case let .visit(v):
                            Text(v.person.name)
                        case let .person(p):
                            NavigationLink {
                                PersonView(person: p)
                            } label: {
                                VisitView(person: p)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Hub Visitors")
            .navigationBarTitleDisplayMode(.large)
        }
        .alert(isPresented: $showsError, error: error) {}
        .refreshable { await refresh() }
        .task { await refresh() }
    }

    func refresh() async {
        do {
            try await updateVisitors()
            if me == nil {
                me = try await service.me
            }
            try await loadVisitors()
        } catch {
            self.error = error as? RecurseServiceError ?? .otherError(error)
            showsError = true
        }
    }

    func checkin() {
        Task {
            do {
                try await service.checkin()
                try await updateVisitors()
                try await loadVisitors()
            } catch {
                self.error = error as? RecurseServiceError ?? .otherError(error)
                showsError = true
            }
        }
    }

    func updateVisitors() async throws {
        visitors = try await service.visitors()
            .sorted { a, b in a.person.name < b.person.name }
            .map {
                VisitToPerson(visit: $0)
            }
    }

    func loadVisitors() async throws {
        for v in visitors {
            try await v.load(service: service)
        }
    }
}
