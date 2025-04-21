// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

struct RecurseTokens: Decodable {
    // id of the token, not the person
    let id: Int
    // authentication token
    let token: String
    let description: String
    //     "last_used_at":null
}
