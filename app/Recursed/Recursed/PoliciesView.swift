// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct PoliciesView: View {
    @State var control: BotControl

    var body: some View {
        VStack {
            List {
                Text("Policies").font(.largeTitle)
                Text(try! AttributedString(
                    markdown:
                    "1\\. **\(control.name) guarantees nothing!**" +
                        " If you absolutely need to get in," +
                        " find someone with a keyfob."
                ))
                Text("2. Observe all rules governing the RC space.")
                Text("3. \(control.name) usage is logged.")
            }
        }
        .navigationTitle("Policies")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    PoliciesView(control: BotControl(name: "SampleBot"))
}
