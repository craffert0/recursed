// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation

@Observable
class LicenseModel {
    var data: String = "GPLv2"

    init() {
        if let filepath = Bundle.main.path(forResource: "LICENSE",
                                           ofType: "txt")
        {
            do {
                let contents = try String(contentsOfFile: filepath,
                                          encoding: .utf8)
                Task { @MainActor in
                    self.data = contents
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("File not found")
        }
    }
}
