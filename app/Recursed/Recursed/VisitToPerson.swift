// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation

@Observable
class VisitToPerson {
    enum State {
        case visit(RecurseHubVisit)
        case person(RecursePerson)
    }

    var state: State

    init(visit: RecurseHubVisit) {
        state = .visit(visit)
    }

    func load(service: RecurseService) async throws {
        if case let .visit(v) = state {
            state = try await .person(service.person(id: v.person.id))
        }
    }
}

extension VisitToPerson: Identifiable {
    var id: Int {
        switch state {
        case let .visit(v):
            v.person.id
        case let .person(p):
            p.id
        }
    }
}
