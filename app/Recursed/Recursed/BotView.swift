// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct BotView<Content: View>: View {
    @State var control: BotControl
    let content: Content
    @State var isPoliciesPresented: Bool = false

    init(control: BotControl,
         @ViewBuilder content: () -> Content)
    {
        self.control = control
        self.content = content()
    }

    var body: some View {
        VStack {
            List {
                Text("Instructions").font(.largeTitle)
                content
            }
            Spacer()
            Button("Policies") {
                isPoliciesPresented = true
            }
            .popover(isPresented: $isPoliciesPresented) {
                PoliciesView(control: control)
            }
        }
        .navigationTitle(control.name)
        .navigationBarTitleDisplayMode(.large)
        .alert(control.alertMessage,
               isPresented: $control.showAlert) {}
        .overlay(alignment: .center) {
            if control.buzzing {
                ProgressView()
            }
        }
    }
}

#Preview {
    NavigationView {
        BotView(control: BotControl(name: "SampleBot")) {
            Text(
                "1. A robot may not injure a human being or," +
                    " through inaction, allow a human being to come to harm."
            )
            Text(
                "2. A robot must obey the orders given it by human beings" +
                    " except where such orders would conflict with the" +
                    " First Law."
            )
            Text(
                "3. A robot must protect its own existence as long as" +
                    " such protection does not conflict with the First" +
                    " or Second Law."
            )
        }
    }
}
