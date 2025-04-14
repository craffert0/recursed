// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct PersonView: View {
    let person: RecursePerson

    var body: some View {
        VStack {
            Text(person.name)
            if let email = person.email {
                Text(email)
            }
        }
    }
}
