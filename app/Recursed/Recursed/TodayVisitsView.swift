// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import SwiftUI

struct TodayVisitsView: View {
    @State var people: [RecursePerson] = []
    @State var showsError: Bool = false
    @State var error: RecurseServiceError?

    let columns = [
        GridItem(.adaptive(minimum: 80)),
    ]

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
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
            people = try await RecurseService.global.visitors()
        } catch {
            self.error = error as? RecurseServiceError ?? .otherError(error)
            showsError = true
        }
    }
}
