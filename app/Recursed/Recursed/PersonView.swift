// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct PersonView: View {
    let person: RecursePerson

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
            Text(person.name)
            if let email = person.email {
                Link(email, destination: URL(string: "mailto:\(email)")!)
            }
        }
    }
}
