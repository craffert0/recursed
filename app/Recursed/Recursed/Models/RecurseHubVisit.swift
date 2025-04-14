// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

struct RecurseHubVisit: Decodable {
    let person: Person
    let date: String
    // "date": "2025-04-14",
    // "app_data": {},
    // "notes": "",
    // "created_at": "2025-04-14T09:41:26-04:00",
    // "updated_at": "2025-04-14T09:41:26-04:00",
    // "created_by_app": "Hub Kiosk",
    // "updated_by_app": "Hub Kiosk"

    struct Person: Decodable {
        let id: Int
        let name: String
    }
}

extension RecurseHubVisit: Identifiable {
    var id: String { "\(person.id).date" }
}
