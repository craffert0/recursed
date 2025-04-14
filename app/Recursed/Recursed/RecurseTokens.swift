// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

enum RecurseTokens {
    static let kRequestBody = "description=Recursed+iOS".data(using: .utf8)!

    struct Response: Decodable {
        let id: Int
        let token: String
        let description: String
        //     "last_used_at":null
    }
}
