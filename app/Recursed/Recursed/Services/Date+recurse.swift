// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

extension Date {
    var recurse: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: self)
    }

    var isElevatorUnlocked: Bool {
        let wh = Calendar.current.dateComponents([.weekday, .hour],
                                                 from: self)
        switch (wh.weekday!, wh.hour!) {
        case (2 ... 6, 10 ... 17):
            return true
        default:
            return false
        }
    }
}
