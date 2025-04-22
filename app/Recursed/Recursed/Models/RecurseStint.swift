// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

struct RecurseStint: Decodable {
    var id: Int
    var for_half_batch: Bool
    var in_progress: Bool
    var start_date: String // "2025-02-17"
    var type: String

    var title: String?
    var end_date: String?
    var batch: Batch?

    struct Batch: Decodable {
        var id: Int
        var name: String
        var short_name: String?
        var alt_name: String?
    }
}

extension RecurseStint: Identifiable {}
