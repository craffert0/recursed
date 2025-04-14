// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct MainView: View {
    @State var person: RecursePerson?
    @State var showsError: Bool = false
    @State var error: RecurseServiceError?
    var service = RecurseService.global

    var body: some View {
        VStack {
            if let person {
                PersonView(person: person)
            }
            Button("Logout") {
                service.logout()
            }
        }
        .alert(isPresented: $showsError, error: error) {}
        .task { await getMe() }
    }

    func getMe() async {
        do {
            person = try await service.getMe()
        } catch {
            self.error = error as? RecurseServiceError ?? .otherError(error)
            showsError = true
        }
    }
}
