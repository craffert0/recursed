// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

extension VStack {
    func apply(bot control: Binding<BotControl>) -> some View {
        navigationTitle(control.name)
            .navigationBarTitleDisplayMode(.large)
            .alert(control.alertMessage.wrappedValue,
                   isPresented: control.showAlert) {}
            .overlay(alignment: .center) {
                if control.buzzing.wrappedValue {
                    ProgressView()
                }
            }
    }
}
