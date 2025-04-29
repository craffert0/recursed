// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

extension URLSession {
    func object<T: Decodable>(path: String,
                              httpMethod: String = "GET") async throws -> T
    {
        guard let authorizationToken =
            PreferencesModel.global.authorizationToken
        else {
            throw RecurseServiceError.loggedOut
        }
        let url = URL(recurse: path)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Bearer " + authorizationToken,
                         forHTTPHeaderField: "Authorization")
        let (data, response) = try await data(for: request)

        let http_response = response as! HTTPURLResponse
        guard http_response.statusCode == 200 else {
            throw RecurseServiceError.httpError(http_response.statusCode)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
