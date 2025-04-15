// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

extension URL {
    init(recurse: String) {
        self.init(string: "https://www.recurse.com/api/v1/\(recurse)")!
    }
}
