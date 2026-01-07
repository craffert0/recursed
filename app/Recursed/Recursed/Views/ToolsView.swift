// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct ToolsView: View {
    @Environment(RecurseService.self) var service
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    @State var checking: Bool = false
    @State var isElevatorUnlocked: Bool = Date.now.isElevatorUnlocked

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                doorbotView
                Spacer()
                elevatorBotView
                Spacer()
                stairwellBotView
                Spacer()
                checkinView
                Spacer()
            }
            .navigationTitle("Hub Tools")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear { isElevatorUnlocked = Date.now.isElevatorUnlocked }
        .alert(alertMessage, isPresented: $showAlert) {}
        .overlay(alignment: .center) {
            if checking {
                ProgressView()
            }
        }
        .task { await service.updateDoorbotStatus() }
    }

    private var doorbotView: some View {
        NavigationLink {
            DoorbotView()
        } label: {
            label("DoorBot", "door.left.hand.closed")
        }
    }

    private var elevatorBotView: some View {
        NavigationLink {
            if isElevatorUnlocked {
                ManualElevatorView()
            } else {
                ElevatorBotView()
            }
        } label: {
            label("Elevator", "arrowshape.up")
        }
    }

    private var stairwellBotView: some View {
        NavigationLink {
            StairwellBotView()
        } label: {
            label("StairwellBot", "figure.stairs")
        }
    }

    private var checkinView: some View {
        Button {
            checkin()
        } label: {
            label("Check in", "checkmark.seal")
        }
    }

    private func label(_ text: String, _ systemName: String) -> some View {
        HStack {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            Text(text).font(.largeTitle)
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

#Preview {
    ToolsView()
        .environment(RecurseService())
}
