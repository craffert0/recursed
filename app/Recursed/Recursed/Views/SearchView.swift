// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct SearchView: View {
    @Environment(RecurseService.self) var service

    @State var model: SearchModel

    @State var query: String = ""
    @State var selectedBatch: RecurseBatch = SearchView.kAnyBatch
    @State var selectedRole: RecurseRole = .no_role

    @FocusState private var queryIsFocused
    @State private var showOptions: Bool = false

    private static let kAnyBatch =
        RecurseBatch(id: 0, name: "Any Batch", start_date: "", end_date: "")

    init(people: [RecursePerson] = []) {
        model = SearchModel(people: people)
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    searchFieldsSection
                    resultsSection
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
        }
        .alert(isPresented: $model.showsError, error: model.error) {}
        .overlay(alignment: .center) {
            if model.searching {
                ProgressView()
            }
        }
        .task {
            try? await service.loadBatches()
        }
    }

    var searchFieldsSection: some View {
        Section {
            TextField("Search name or keyword", text: $query)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .focused($queryIsFocused)
                .onSubmit { search() }

            DisclosureGroup(isExpanded: $showOptions) {
                Picker("Batch", selection: $selectedBatch) {
                    Text(SearchView.kAnyBatch.name).tag(SearchView.kAnyBatch)
                    ForEach(service.allBatches) { b in
                        Text(b.name).tag(b)
                    }
                }
                Picker("Role", selection: $selectedRole) {
                    ForEach(RecurseRole.allCases) { r in
                        Text(r.description).tag(r)
                    }
                }
                Button("Search") { search() }
                    .frame(maxWidth: .infinity, alignment: .center)
            } label: {
                Text(selectedBatch.name)
                Spacer()
                Text(selectedRole.description)
            }
        }
    }

    var resultsSection: some View {
        Section {
            if !model.people.isEmpty {
                PeopleGridView(people: $model.people).padding(.top)
            } else if model.haveSearched {
                ContentUnavailableView.search
            }
        }
    }
}

extension SearchView {
    @MainActor
    private func search() {
        showOptions = false
        queryIsFocused = false
        var args: [String: String] = [:]
        if query != "" {
            args["query"] = query
        }
        if selectedBatch.id != 0 {
            args["batch_id"] = "\(selectedBatch.id)"
        }
        if selectedRole != .no_role {
            args["role"] = selectedRole.raw
        }
        Task {
            await model.search(args: args)
        }
    }
}

#Preview {
    TabView {
        Tab("some", systemImage: "magnifyingglass.circle.fill") {
            SearchView(people: .fakePeople)
        }
        Tab("empty", systemImage: "magnifyingglass.circle.fill") {
            SearchView()
        }
    }
    .environment(RecurseService())
}
