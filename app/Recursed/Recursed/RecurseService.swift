// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation
import UIKit

@Observable
class RecurseService {
    static let global = RecurseService()

    var currentVisitors: [RecursePerson] = []
    var currentRecursers: [RecursePerson] = []
    var searchResults: [RecursePerson] = []
    var allBatches: [RecurseBatch] = []
    var status: Status =
        PreferencesModel.global.authorizationToken == nil
            ? .loggedOut : .loggedIn

    private let preferences = PreferencesModel.global

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

    @MainActor
    func login(user: String, password: String) async {
        do {
            try await loginThrowing(user: user, password: password)
            try await loadMe()
            status = .loggedIn
        } catch {
            status = .from(error: error)
        }
    }

    @MainActor
    func login(token: String) async {
        do {
            preferences.authorizationToken = token
            try await loadMe()
            status = .loggedIn
        } catch {
            preferences.authorizationToken = nil
            status = .from(error: error)
        }
    }

    func loadMe() async throws {
        if preferences.userId != nil {
            return
        }
        let newMe: RecursePerson = try await run(path: "profiles/me")
        Task { @MainActor in
            preferences.userId = newMe.id
        }
    }

    func fetchVisitors() async throws {
        var results: [RecursePerson] = []
        var visits: [RecurseHubVisit] =
            try await run(path: "hub_visits?date=\(Date.now.recurse)")
        visits.sort { a, b in a.person.name < b.person.name }
        if currentVisitors.count == 0 {
            for v in visits {
                let p = try await person(id: v.person.id)
                Task { @MainActor in
                    currentVisitors.append(p)
                }
            }
        } else {
            for v in visits {
                try await results.append(person(id: v.person.id))
            }
            Task { @MainActor in
                currentVisitors = results
            }
        }
    }

    func fetchCurrent() async throws {
        let people = try await fetchPeople(args: ["scope": "current"])
        Task { @MainActor in
            currentRecursers = people.sorted { a, b in a.name < b.name }
        }
    }

    func search(
        query: String, batch: RecurseBatch, role: RecurseRole
    ) async throws {
        var args: [String: String] = ["query": query]
        if batch.id != 0 {
            args["batch_id"] = "\(batch.id)"
        }
        if role != .no_role {
            args["role"] = role.raw
        }
        let people = try await fetchPeople(args: args)
        Task { @MainActor in
            searchResults = people.sorted { a, b in a.name < b.name }
        }
    }

    private func fetchPeople(args: [String: String]) async throws
        -> [RecursePerson]
    {
        let argString = args
            .map { k, v in "\(k)=\(v)" }
            .joined(separator: "&")
        var results: [RecursePerson] = []
        while true {
            let path = "profiles?\(argString)&offset=\(results.count)"
            let batch: [RecursePerson] = try await run(path: path)
            if batch.count == 0 {
                break
            }
            results += batch
        }
        return results
    }

    func loadBatches() async throws {
        let batches: [RecurseBatch] = try await run(path: "batches")
        Task { @MainActor in
            allBatches = batches
        }
    }

    private var people: [Int: RecursePerson] = [:]
    private func person(id: Int) async throws -> RecursePerson {
        if let person = people[id] {
            return person
        }

        let person: RecursePerson = try await run(path: "profiles/\(id)")
        people[id] = person
        return person
    }

    @MainActor
    func logout() {
        preferences.authorizationToken = nil
        preferences.userId = nil
        status = .loggedOut
    }

    @MainActor
    func checkin() async throws {
        guard let userId = preferences.userId else {
            throw RecurseServiceError.loggedOut
        }
        let _: RecurseHubVisit =
            try await run(path: "hub_visits/\(userId)/\(Date.now.recurse)",
                          httpMethod: "PATCH")
    }

    func doorbotBuzz() async throws -> String {
        try await doorbotRun(command: "buzz")
    }

    func elevatorBuzz() async throws -> String {
        try await doorbotRun(command: "unlock")
    }

    private func doorbotRun(command: String) async throws -> String {
        guard let authorizationToken = preferences.authorizationToken else {
            throw RecurseServiceError.loggedOut
        }
        let url =
            URL(string: "https://doorbot.recurse.com/\(command)_mobile")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer " + authorizationToken,
                         forHTTPHeaderField: "Authorization")
        let (data, response) =
            try await URLSession.shared.data(for: request)

        let http_response = response as! HTTPURLResponse
        guard http_response.statusCode == 200 else {
            throw RecurseServiceError.httpError(http_response.statusCode)
        }
        return String(data: data, encoding: .utf8)!
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
