// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct VisitView: View {
    @State var person: RecursePerson

    var body: some View {
        Text(person.name)
    }
}
