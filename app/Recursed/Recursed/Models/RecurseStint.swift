// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

struct RecurseStint: Decodable {
    let id: Int
    let for_half_batch: Bool
    let in_progress: Bool
    let start_date: String // "2025-02-17"
    let type: String

    let title: String?
    let end_date: String?
    let batch: RecurseBatch?
}

extension RecurseStint: Identifiable {}
