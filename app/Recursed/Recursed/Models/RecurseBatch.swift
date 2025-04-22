// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

// /api/v1/batches -> [RecurseBatchMetadata]
struct RecurseBatch: Decodable {
    let id: Int
    let name: String
    let start_date: String // "2025-02-17"
    let end_date: String
}

extension RecurseBatch: Identifiable {}

extension RecurseBatch: Hashable {}
