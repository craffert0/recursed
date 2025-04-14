// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct LoginView: View {
    @ObservedObject var preferences = PreferencesModel.global
    @State var password: String = ""
    @State var showsError: Bool = false
    @State var error: RecurseServiceError?
    let service = RecurseService.global

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(text: preferences.$emailAddress,
                              prompt: Text("email address"))
                    {
                        Text("email address")
                    }
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    #endif
                    .disableAutocorrection(true)
                    .textContentType(.username)
                    .keyboardType(.emailAddress)
                    .onSubmit { login() }

                    SecureField(text: $password,
                                prompt: Text("password"))
                    {
                        Text("Password")
                    }
                    .textContentType(.password)
                    .onSubmit { login() }
                } header: {
                    Text("Account")
                }
            }.navigationTitle("Sign in")
            Button("Login") {
                login()
            }.buttonStyle(.bordered)
        }
        .alert(isPresented: $showsError, error: error) {}
    }

    private func login() {
        Task {
            await service.login(user: preferences.emailAddress,
                                password: password)
            DispatchQueue.main.async {
                if case let .error(error) = service.status {
                    self.error = error
                    showsError = true
                }
            }
        }
    }
}
