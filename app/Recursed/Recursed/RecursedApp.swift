// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftData
import SwiftUI

@main
struct RecursedApp: App {
    @StateObject var service = RecurseService()
    @StateObject var location = LocationService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(service)
                .environmentObject(location)
        }
    }
}
