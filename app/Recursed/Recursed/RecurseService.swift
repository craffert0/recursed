// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation
import UIKit

@Observable class RecurseService {
    static let global = RecurseService()

    enum Status {
        case loggedOut
        case loggedIn
        case error(RecurseServiceError)
        case otherError(Error)

        static func from(error: Error) -> Status {
            if let recurse_error = error as? RecurseServiceError {
                .error(recurse_error)
            } else {
                .otherError(error)
            }
        }
    }

    var status: Status =
        PreferencesModel.global.authorizationToken == nil
            ? .loggedOut : .loggedIn

    private let preferences = PreferencesModel.global

    private var actual_me: RecursePerson?
    var me: RecursePerson {
        get async throws {
            if actual_me == nil {
                actual_me = try await getMe()
            }
            return actual_me!
        }
    }

    func login(user: String, password: String) async {
        do {
            try await loginThrowing(user: user, password: password)
            status = .loggedIn
        } catch {
            status = .from(error: error)
        }
    }

    func logout() {
        preferences.authorizationToken = nil
        status = .loggedOut
    }

    func visitors() async throws -> [RecursePerson] {
        var result: [RecursePerson] = []
        for v in try await curentVisits() {
            try await result.append(person(id: v.person.id))
        }
        return result.sorted { a, b in a.name < b.name }
    }

    func person(id: Int) async throws -> RecursePerson {
        guard let authorizationToken = preferences.authorizationToken else {
            throw RecurseServiceError.loggedOut
        }
        let url =
            URL(string: "https://www.recurse.com/api/v1/profiles/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + authorizationToken,
                         forHTTPHeaderField: "Authorization")
        let (data, response) =
            try await URLSession.shared.data(for: request)

        let http_response = response as! HTTPURLResponse
        guard http_response.statusCode == 200 else {
            throw RecurseServiceError.httpError(http_response.statusCode)
        }
        return try JSONDecoder().decode(RecursePerson.self, from: data)
    }

    private func curentVisits() async throws -> [RecurseHubVisit] {
        guard let authorizationToken = preferences.authorizationToken else {
            throw RecurseServiceError.loggedOut
        }
        let url = URL(string: "https://www.recurse.com/api/v1/hub_visits")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + authorizationToken,
                         forHTTPHeaderField: "Authorization")
        let (data, response) =
            try await URLSession.shared.data(for: request)

        let http_response = response as! HTTPURLResponse
        guard http_response.statusCode == 200 else {
            throw RecurseServiceError.httpError(http_response.statusCode)
        }
        return try JSONDecoder().decode([RecurseHubVisit].self, from: data)
    }

    func current() async throws -> [RecursePerson] {
        guard let authorizationToken = preferences.authorizationToken else {
            throw RecurseServiceError.loggedOut
        }
        var results: [RecursePerson] = []
        while true {
            let url = URL(string: "https://www.recurse.com/api/v1/profiles?scope=current&offset=\(results.count)")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer " + authorizationToken,
                             forHTTPHeaderField: "Authorization")
            let (data, response) =
                try await URLSession.shared.data(for: request)

            let http_response = response as! HTTPURLResponse
            guard http_response.statusCode == 200 else {
                throw RecurseServiceError.httpError(http_response.statusCode)
            }
            let batch =
                try JSONDecoder().decode([RecursePerson].self, from: data)
            if batch.count == 0 {
                return results
            }
            results += batch
        }
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
        request.httpBody =
            await "description=Recursed on \(UIDevice.current.name)"
                .split(separator: " ")
                .joined(separator: "+")
                .data(using: .utf8)!
        let (data, response) =
            try await URLSession.shared.data(for: request)

        let http_response = response as! HTTPURLResponse
        guard http_response.statusCode == 200 else {
            throw RecurseServiceError.httpError(http_response.statusCode)
        }
        preferences.authorizationToken =
            try JSONDecoder().decode(RecurseTokens.self,
                                     from: data).token
    }

    private func getMe() async throws -> RecursePerson {
        guard let authorizationToken = preferences.authorizationToken else {
            throw RecurseServiceError.loggedOut
        }
        let url = URL(string: "https://www.recurse.com/api/v1/profiles/me")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + authorizationToken,
                         forHTTPHeaderField: "Authorization")
        let (data, response) =
            try await URLSession.shared.data(for: request)

        let http_response = response as! HTTPURLResponse
        guard http_response.statusCode == 200 else {
            throw RecurseServiceError.httpError(http_response.statusCode)
        }
        return try JSONDecoder().decode(RecursePerson.self, from: data)
    }
}
