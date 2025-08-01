// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

extension URLCache {
    static let image = URLCache(memoryCapacity: 512_000_000,
                                diskCapacity: 10_000_000_000)
}
