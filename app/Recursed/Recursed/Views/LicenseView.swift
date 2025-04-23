// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct LicenseView: View {
    @State var model: LicenseModel

    var body: some View {
        ScrollView {
            VStack {
                Text(model.data)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .navigationBarTitle("License")
        // .navigationBarItems(trailing: Button("Check In") {})
    }
}
