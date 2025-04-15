// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct LoginView: View {
    enum Which {
        case password
        case key
    }

    @ObservedObject var preferences = PreferencesModel.global
    @State var password: String = ""
    @State var accessToken: String = ""
    @State var showsError: Bool = false
    @State var error: RecurseServiceError?
    @State var selection: Which = .key

    let service = RecurseService.global

    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                Tab("Key", systemImage: "key", value: Which.key) {
                    keyBody
                }
                Tab("Password", systemImage: "house.circle.fill", value: Which.password) {
                    loginBody
                }
            }
            Button("Login") {
                login()
            }.buttonStyle(.bordered)
        }
        .alert(isPresented: $showsError, error: error) {}
    }

    var keyBody: some View {
        Form {
            Section {
                Text(try! AttributedString(
                    markdown:
                    "Create a personal access token on" +
                        " [the Recurse settings page]" +
                        "(https://www.recurse.com/settings/apps)" +
                        " and enter it below, or login with your" +
                        " email and password in the next tab."
                ))

                SecureField(text: $accessToken,
                            prompt: Text("personal access token"))
                {
                    Text("personal access token")
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .onSubmit { login() }
            } header: {
                Text("Personal Access Token")
            }
        }
    }

    var loginBody: some View {
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
    }

    private func login() {
        Task {
            switch selection {
            case .password:
                await service.login(user: preferences.emailAddress,
                                    password: password)
            case .key:
                await service.login(token: accessToken)
            }

            DispatchQueue.main.async {
                if case let .error(error) = service.status {
                    self.error = error
                    showsError = true
                }
            }
        }
    }
}
