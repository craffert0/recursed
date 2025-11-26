// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct BotView<Content: View>: View {
    @Environment(RecurseService.self) var service
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
        Form {
            Section {
                Text("Instructions").font(.largeTitle)
                content
            }

            switch service.doorbotStatus {
            case .unknown: problemView("Doorbot status unknown")
            case .good: EmptyView()
            case let .bad(reason): problemView("Doorbot may be down: \(reason)")
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

    private func problemView(_ problem: String) -> some View {
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
}

#Preview {
    let t1 = "1. A robot may not injure a human being or," +
        " through inaction, allow a human being" +
        " to come to harm."
    let t2 = "2. A robot must obey the orders given it by" +
        " human beings except where such orders would" +
        " conflict with the First Law."
    let t3 = "3. A robot must protect its own existence as long as" +
        " such protection does not conflict with the First" +
        " or Second Law."
    TabView {
        Tab("good", systemImage: "magnifyingglass.circle.fill") {
            BotView(control: BotControl(name: "SampleBot")) {
                Text(t1)
                Text(t2)
                Text(t3)
            }
            .environment({
                let r = RecurseService()
                r.doorbotStatus = .good
                return r
            }())
        }
        Tab("bad", systemImage: "magnifyingglass.circle.fill") {
            BotView(control: BotControl(name: "SampleBot")) {
                Text(t1)
                Text(t2)
                Text(t3)
            }
            .environment({
                let r = RecurseService()
                r.doorbotStatus = .bad("We hebben een serieus probleem")
                return r
            }())
        }
        Tab("unknown", systemImage: "magnifyingglass.circle.fill") {
            BotView(control: BotControl(name: "SampleBot")) {
                Text(t1)
                Text(t2)
                Text(t3)
            }
            .environment({
                let r = RecurseService()
                r.doorbotStatus = .unknown
                return r
            }())
        }
    }
}
