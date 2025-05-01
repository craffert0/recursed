// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct SimpleSearchView: View {
    @State var model = SearchModel()
    @State var title: String
    @State var searchArgs: [String: String]
    @State var haveSearched: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                PeopleGridView(people: $model.people)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
        }
        .alert(isPresented: $model.showsError, error: model.error) {}
        .overlay(alignment: .center) {
            if model.searching {
                ProgressView()
            }
        }
        .task {
            if !haveSearched {
                haveSearched = true
                await model.search(args: searchArgs)
            }
        }
    }
}
