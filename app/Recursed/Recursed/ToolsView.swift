// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct ToolsView: View {
    @State private var service = RecurseService.global
    @State private var location = LocationService.global
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    @State var checking: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                NavigationLink {
                    DoorbotView()
                } label: {
                    Text("DoorBot").font(.largeTitle)
                }
                Spacer()
                NavigationLink {
                    ElevatorBotView()
                } label: {
                    Text("ElevatorBot").font(.largeTitle)
                }
                Spacer()
                NavigationLink {
                    ManualElevatorView()
                } label: {
                    Text("ManualElevator").font(.largeTitle)
                }
                if location.nearRecurse397 {
                    Spacer()
                    Button("Check in?") {
                        checkin()
                    }
                    .font(.largeTitle)
                    .disabled(checking)
                }
                Spacer()
            }
            .navigationTitle("Tools")
            .navigationBarTitleDisplayMode(.large)
        }
        .alert(alertMessage, isPresented: $showAlert) {}
        .overlay(alignment: .center) {
            if checking {
                ProgressView()
            }
        }
    }

    private func checkin() {
        checking = true
        Task {
            var message = "checked in"
            do {
                try await service.checkin()
            } catch {
                message = "\(error)"
            }
            Task { @MainActor in
                alertMessage = message
                showAlert = true
                checking = false
            }
        }
    }
}
