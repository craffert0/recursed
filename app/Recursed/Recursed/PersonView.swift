// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct PersonView: View {
    @State var person: RecursePerson

    var body: some View {
        VStack {
            if let image_path = person.image_path {
                AsyncImage(url: URL(string: image_path)!) {
                    $0
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 150)
            }
            HStack {
                ForEach(person.stints) {
                    if let n = $0.batch?.short_name {
                        Text(n)
                    }
                }
            }
            if let email = person.email {
                Link(email, destination: URL(string: "mailto:\(email)")!)
            }
            if let before_rc = person.before_rc_hl {
                Text("Before RC").font(.headline)
                Text(before_rc)
            }
            if person.stints.contains(where: \.in_progress),
               let during_rc = person.during_rc_hl
            {
                Text("During RC").font(.headline)
                Text(during_rc)
            }
            Spacer()
        }
        .navigationTitle(person.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PersonView(person: RecursePerson.fakePerson)
    }
}
