// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct MainView: View {
    var service = RecurseService.global

    var body: some View {
        Button("Logout") {
            service.logout()
        }
    }
}
