// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation

@Observable class RecurseService {
    static let global = RecurseService()

    enum Status {
        case loggedOut
        case loggedIn
        case error(RecurseServiceError)
        case otherError(Error)
    }

    var status: Status =
        PreferencesModel.global.authorizationToken == nil
            ? .loggedOut : .loggedIn

    private let preferences = PreferencesModel.global

    func login(user: String, password: String) async {
        do {
            try await loginThrowing(user: user, password: password)
            status = .loggedIn
        } catch {
            if let recurse_error = error as? RecurseServiceError {
                status = .error(recurse_error)
            } else {
                status = .otherError(error)
            }
        }
    }

    func logout() {
        preferences.authorizationToken = nil
        status = .loggedOut
    }

    private func loginThrowing(user: String, password: String) async throws {
        guard let encoded = "\(user):\(password)"
            .data(using: .utf8)?
            .base64EncodedString()
        else {
            throw RecurseServiceError.cannotEncode
        }

        let url = URL(string: "https://www.recurse.com/api/v1/tokens")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("Basic " + encoded,
                         forHTTPHeaderField: "Authorization")
        request.httpBody = RecurseTokens.kRequestBody
        let (data, response) =
            try await URLSession.shared.data(for: request)

        let http_response = response as! HTTPURLResponse
        guard http_response.statusCode == 200 else {
            throw RecurseServiceError.httpError(http_response.statusCode)
        }
        preferences.authorizationToken =
            try JSONDecoder().decode(RecurseTokens.Response.self,
                                     from: data).token
    }
}
