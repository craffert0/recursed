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
                actual_me = try await run(path: "profiles/me")
            }
            return actual_me!
        }
    }

    private var people: [Int: RecursePerson] = [:]

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
        if let person = people[id] {
            return person
        }

        let person: RecursePerson = try await run(path: "profiles/\(id)")
        people[id] = person
        return person
    }

    @discardableResult
    func checkin() async throws -> RecurseHubVisit {
        try await run(path: "hub_visits/\(me.id)/\(Date.now.recurse)",
                      httpMethod: "PATCH")
    }

    private func curentVisits() async throws -> [RecurseHubVisit] {
        try await run(path: "hub_visits?date=\(Date.now.recurse)")
    }

    func current() async throws -> [RecursePerson] {
        var results: [RecursePerson] = []
        while true {
            let path = "profiles?scope=current&offset=\(results.count)"
            let batch: [RecursePerson] = try await run(path: path)
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

        let url = URL(recurse: "tokens")
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

    private func run<T: Decodable>(path: String,
                                   httpMethod: String = "GET") async throws -> T
    {
        guard let authorizationToken = preferences.authorizationToken else {
            throw RecurseServiceError.loggedOut
        }
        let url = URL(recurse: path)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Bearer " + authorizationToken,
                         forHTTPHeaderField: "Authorization")
        let (data, response) =
            try await URLSession.shared.data(for: request)

        let http_response = response as! HTTPURLResponse
        guard http_response.statusCode == 200 else {
            throw RecurseServiceError.httpError(http_response.statusCode)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
