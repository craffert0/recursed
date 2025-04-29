// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct PeopleGridView: View {
    @Binding var people: [RecursePerson]

    let columns = [
        GridItem(.adaptive(minimum: 80)),
    ]

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(people) { person in
                    NavigationLink {
                        PersonView(person: person)
                    } label: {
                        GridPersonView(person: person)
                    }
                }
            }
        }
    }
}

#Preview {
    let fakePeople = Binding<[RecursePerson]>() { .fakePeople } set: { _ in }
    NavigationView {
        PeopleGridView(people: fakePeople)
    }
}
