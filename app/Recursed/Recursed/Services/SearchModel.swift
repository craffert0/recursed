// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Observation

@Observable
class SearchModel {
    var people: [RecursePerson]
    var searching: Bool = false
    var haveSearched: Bool = false
    var showsError: Bool = false
    var error: RecurseServiceError?
    var prefs = PreferencesModel.global

    init(people: [RecursePerson] = []) {
        self.people = people
    }

    func search(args: [String: String]) async {
        if prefs.debugMode {
            Task { @MainActor in
                people = .fakePeople
                searching = false
                haveSearched = true
                showsError = false
                error = nil
            }
            return
        }

        Task { @MainActor in
            people = []
            searching = true
            haveSearched = false
            showsError = false
            error = nil
        }
        do {
            let loader = try PeopleLoader(args: args)
            var maybeMore = true
            while maybeMore {
                let batch = try await loader.next()
                maybeMore = !batch.isEmpty
                Task { @MainActor in
                    if batch.isEmpty {
                        searching = false
                        haveSearched = true
                    } else {
                        people += batch
                    }
                }
            }
        } catch {
            let e = RecurseServiceError.from(error: error)
            Task { @MainActor in
                self.error = e
                searching = false
                showsError = true
            }
        }
    }
}
