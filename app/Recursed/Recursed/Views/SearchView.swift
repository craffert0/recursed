// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct SearchView: View {
    @Environment(RecurseService.self) var service

    @State private var query: String = ""
    @State private var selectedBatch: RecurseBatch = SearchView.kAnyBatch
    @State private var selectedRole: RecurseRole = .no_role

    @State private var showOptions: Bool = false
    @State private var searching: Bool = false
    @State private var showsError: Bool = false
    @State private var error: RecurseServiceError?

    private static let kAnyBatch =
        RecurseBatch(id: 0, name: "Any Batch", start_date: "", end_date: "")

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Search name or keyword", text: $query)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .onSubmit { search() }

                        DisclosureGroup(isExpanded: $showOptions) {
                            Picker("Batch", selection: $selectedBatch) {
                                Text(SearchView.kAnyBatch.name)
                                    .tag(SearchView.kAnyBatch)
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
                                .frame(maxWidth: .infinity,
                                       alignment: .center)
                        } label: {
                            Text(selectedBatch.name)
                            Spacer()
                            Text(selectedRole.description)
                        }
                    }
                    if !service.searchResults.isEmpty {
                        Section {
                            PeopleGridView(people: service.searchResults)
                                .padding(.top)
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
        }
        .alert(isPresented: $showsError, error: error) {}
        .overlay(alignment: .center) {
            if searching {
                ProgressView()
            }
        }
        .task { try? await service.loadBatches() }
    }

    private func search() {
        guard !searching else { return }
        searching = true
        showOptions = false
        error = nil
        Task {
            var my_error: RecurseServiceError? = nil
            do {
                try await service.search(query: query,
                                         batchId: selectedBatch.id,
                                         role: selectedRole)
            } catch {
                my_error = RecurseServiceError.from(error: error)
            }
            Task { @MainActor in
                error = my_error
                showsError = my_error != nil
                searching = false
            }
        }
    }
}

#Preview {
    SearchView()
        .environment(
            {
                let service = RecurseService()
                service.searchResults = RecursePerson.fakePeople
                return service
            }())
}
