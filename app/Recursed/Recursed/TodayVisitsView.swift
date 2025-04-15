// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import SwiftUI

struct TodayVisitsView: View {
    @State var me: RecursePerson?
    @State var people: [RecursePerson] = []
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
                   !people.contains(where: { $0.id == me.id })
                {
                    Button("Check in?") {
                        checkin()
                    }.buttonStyle(.bordered)
                }
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(people) { p in
                        NavigationLink {
                            PersonView(person: p)
                        } label: {
                            VisitView(person: p)
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
            people = try await service.visitors()
            if me == nil {
                me = try await service.me
            }
        } catch {
            self.error = error as? RecurseServiceError ?? .otherError(error)
            showsError = true
        }
    }

    func checkin() {
        Task {
            do {
                try await service.checkin()
                people = try await service.visitors()
            } catch {
                self.error = error as? RecurseServiceError ?? .otherError(error)
                showsError = true
            }
        }
    }
}
