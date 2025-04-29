// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct PersonView: View {
    @State var person: RecursePerson

    var body: some View {
        ScrollView {
            imageView
            stintsView
            connectionsView
            SectionView(title: "Bio", text: person.bio_hl)
            SectionView(title: "Before RC", text: person.before_rc_hl)
            if person.stints.contains(where: \.in_progress) {
                SectionView(title: "During RC", text: person.during_rc_hl)
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var navigationTitle: String {
        if let pronouns = person.pronouns, pronouns != "" {
            "\(person.name) (\(pronouns))"
        } else {
            person.name
        }
    }

    private var imageView: some View {
        VStack {
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
        }
    }

    private var stintsView: some View {
        HStack {
            ForEach(person.stints) {
                if let batch = $0.batch {
                    NavigationLink {
                        SimpleSearchView(
                            title: batch.name,
                            searchArgs: ["batch_id": "\(batch.id)"]
                        )
                    } label: {
                        Text(batch.short_name ?? batch.name)
                    }
                }
            }
        }
    }

    private var connectionsView: some View {
        HStack {
            Spacer()

            ConnectionLinkView(
                url: URL(string: "https://recurse.com/directory/" +
                    person.slug)!,
                systemImage: "globe"
            )

            if let zoom_url = person.zoom_url,
               let url = URL(string: zoom_url)
            {
                ConnectionLinkView(url: url,
                                   systemImage: "video")
            }
            if let email = person.email,
               let url = URL(string: "mailto:\(email)")
            {
                ConnectionLinkView(url: url,
                                   systemImage: "envelope")
            }
            if let phone = person.unformatted_phone_number,
               let url = URL(string: "tel:\(phone)")
            {
                ConnectionLinkView(url: url,
                                   systemImage: "phone")
            }
        }
    }

    struct ConnectionLinkView: View {
        let url: URL
        let systemImage: String

        var body: some View {
            Link(destination: url) {
                Label("", systemImage: systemImage)
                    .labelStyle(.iconOnly)
            }
            Spacer()
        }
    }

    struct SectionView: View {
        @State var title: String
        @State var text: String?

        var body: some View {
            if let text, text != "" {
                Spacer()
                Text(title).font(.headline)
                Text(text).padding()
            }
        }
    }
}

#Preview {
    NavigationStack {
        PersonView(person: .fakePerson)
    }
}
