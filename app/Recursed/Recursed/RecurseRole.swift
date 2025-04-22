// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

enum RecurseRole: CaseIterable {
    case no_role
    case recurser
    case resident
    case facilitator
    case faculty

    var raw: String {
        switch self {
        case .no_role: "no_role"
        case .recurser: "recurser"
        case .resident: "resident"
        case .facilitator: "facilitator"
        case .faculty: "faculty"
        }
    }
}

extension RecurseRole: Identifiable {
    var id: Self { self }
}

extension RecurseRole: CustomStringConvertible {
    var description: String {
        switch self {
        case .no_role: "Any Role"
        case .recurser: "Recurser"
        case .resident: "Resident"
        case .facilitator: "Facilitator"
        case .faculty: "Faculty"
        }
    }
}
