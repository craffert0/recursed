// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

struct RecurseLocation: Decodable {
    let id: Int
    let name: String
    let short_name: String?
}
