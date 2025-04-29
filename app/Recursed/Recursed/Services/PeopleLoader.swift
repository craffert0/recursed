// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

class PeopleLoader {
    let argString: String
    var count = 0

    init(args: [String: String]) throws {
        guard !args.isEmpty else {
            throw RecurseServiceError.badQuery("must have a qualifier")
        }
        argString = args
            .map { k, v in "\(k)=\(v)" }
            .joined(separator: "&")
    }

    func next() async throws -> [RecursePerson] {
        guard count < 400 else {
            throw RecurseServiceError.badQuery("too many results")
        }

        let path = "profiles?\(argString)&limit=50&offset=\(count)"
        let batch: [RecursePerson] =
            try await URLSession.shared.object(path: path)
        count += batch.count
        return batch
    }
}
