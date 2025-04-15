// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct VisitView: View {
    @State var person: RecursePerson

    var body: some View {
        if let image_path = person.image_path {
            VStack {
                AsyncImage(url: URL(string: image_path)!) {
                    $0.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 75, height: 75)
                Text(person.first_name)
            }
        } else {
            Text(person.name)
        }
    }
}
