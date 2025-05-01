// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct BotView<Content: View>: View {
    @State var control: BotControl
    @State var problem: String?
    let content: Content
    @State var isPoliciesPresented: Bool = false

    init(control: BotControl,
         problem: String? = nil,
         @ViewBuilder content: () -> Content)
    {
        self.control = control
        self.problem = problem
        self.content = content()
    }

    var body: some View {
        Form {
            Section {
                Text("Instructions").font(.largeTitle)
                content
            }
            if let problem {
                Section {
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        Text(problem).font(.largeTitle)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }

            Button("Policies") {
                isPoliciesPresented = true
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .sheet(isPresented: $isPoliciesPresented) {
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
    TabView {
        Tab("good", systemImage: "magnifyingglass.circle.fill") {
            BotView(control: BotControl(name: "SampleBot")) {
                Text(
                    "1. A robot may not injure a human being or," +
                        " through inaction, allow a human being" +
                        " to come to harm."
                )
                Text(
                    "2. A robot must obey the orders given it by" +
                        " human beings except where such orders would" +
                        " conflict with the First Law."
                )
                Text(
                    "3. A robot must protect its own existence as long as" +
                        " such protection does not conflict with the First" +
                        " or Second Law."
                )
            }
        }
        Tab("bad", systemImage: "magnifyingglass.circle.fill") {
            BotView(control: BotControl(name: "SampleBot"),
                    problem: "We hebben een serieus probleem")
            {
                Text(
                    "1. A robot may not injure a human being or," +
                        " through inaction, allow a human being" +
                        " to come to harm."
                )
                Text(
                    "2. A robot must obey the orders given it by" +
                        " human beings except where such orders would" +
                        " conflict with the First Law."
                )
                Text(
                    "3. A robot must protect its own existence as long as" +
                        " such protection does not conflict with the First" +
                        " or Second Law."
                )
            }
        }
    }
}
