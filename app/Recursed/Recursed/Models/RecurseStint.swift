// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

struct RecurseStint: Decodable {
    let id: Int
    let type: String
    let title: String?
    let for_half_batch: Bool
    let in_progress: Bool
    let start_date: String // "2025-02-17"
    let end_date: String?
    let batch: RecurseBatch?
}
