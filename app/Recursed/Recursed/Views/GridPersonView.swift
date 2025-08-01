// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CachedAsyncImage
import SwiftUI

struct GridPersonView: View {
    @State var person: RecursePerson

    var body: some View {
        if let image_path = person.image_path {
            VStack {
                CachedAsyncImage(url: URL(string: image_path)!,
                                 urlCache: .image)
                {
                    $0
                        .resizable()
                        .accessibility(hidden: false)
                        .accessibilityLabel(Text(person.name))
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

#Preview {
    Grid {
        GridPersonView(person: RecursePerson.fakePerson)
    }
}
