// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct PersonView: View {
    @State var person: RecursePerson

    var body: some View {
        ScrollView {
            if let image_path = person.image_path {
                AsyncImage(url: URL(string: image_path)!) {
                    $0
                        .accessibility(hidden: false)
                        .accessibilityLabel(Text(person.name))
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

            connections

            if let bio = person.bio_hl {
                Text("Bio").font(.headline)
                Text(bio)
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
        }
        .navigationTitle(person.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var connections: some View {
        HStack {
            Spacer()

            Link(destination:
                URL(string: "https://recurse.com/directory/" + person.slug)!)
            {
                Label("", systemImage: "globe")
                    .labelStyle(.iconOnly)
            }
            Spacer()

            if let zoom_url = person.zoom_url {
                Link(destination: URL(string: zoom_url)!) {
                    Label("", systemImage: "video")
                        .labelStyle(.iconOnly)
                }
                Spacer()
            }
            if let email = person.email {
                Link(destination: URL(string: "mailto:\(email)")!) {
                    Label("", systemImage: "envelope")
                        .labelStyle(.iconOnly)
                }
                Spacer()
            }
            if let phone = person.unformatted_phone_number {
                Link(destination: URL(string: "tel:\(phone)")!) {
                    Label("", systemImage: "phone")
                        .labelStyle(.iconOnly)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    NavigationStack {
        PersonView(person: RecursePerson.fakePerson)
    }
}
