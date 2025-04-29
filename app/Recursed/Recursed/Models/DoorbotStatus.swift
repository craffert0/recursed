// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

enum DoorbotStatus {
    case unknown
    case good
    case bad(String)

    static func from(response: String) -> DoorbotStatus {
        response == "Doorbot is ok" ? .good : .bad(response)
    }
}
