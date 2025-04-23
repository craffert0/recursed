// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct InfoView: View {
    @Environment(RecurseService.self) var service
    @State private var prefs = PreferencesModel.global
    @State private var thanksMarkdowns = [
        "Thanks to " +
            "[Nick](https://recurse.com/directory/34)" +
            " and " +
            "[Sonali](https://recurse.com/directory/35)" +
            " for founding Recurse," +
            " and all the faculty for all their support.",

        "Special thanks to all the Cursed in batches " +
            "[SP1'25](https://recurse.com/directory?batch=Spring+1%2C+2025)" +
            " and " +
            "[SP2'25](https://recurse.com/directory?batch=Spring+2%2C+2025)" +
            " for their testing and feedback," +
            " and for just being there with me.",
    ]
    private var githubMarkdown =
        "[git@github.com:craffert0/recursed]" +
        "(https://github.com/craffert0/recursed)"

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("All Code Copyright © 2025 Colin Rafferty")
                        .frame(maxWidth: .infinity, alignment: .center)
                    NavigationLink {
                        LicenseView(model: LicenseModel())
                    } label: {
                        Text("Licensed GNU GPLv2.0")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    Text(try! AttributedString(markdown: githubMarkdown))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                Section {
                    ForEach(thanksMarkdowns, id: \.self) {
                        Text(try! AttributedString(markdown: $0))
                    }
                }
                Button("Logout") { service.logout() }
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Recursed!")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    TabView {
        Tab("Info", systemImage: "info.circle.fill") {
            InfoView()
        }
    }
    .environment(RecurseService())
}
