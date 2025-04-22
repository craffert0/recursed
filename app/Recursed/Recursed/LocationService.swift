// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation
import Observation

@Observable
class LocationService: NSObject {
    static let global = LocationService()

    var location: CLLocation? = nil
    var nearRecurse397: Bool = true

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            manager.stopUpdatingLocation()
            Task { @MainActor in
                location = nil
                nearRecurse397 = true
            }
        }
    }

    func locationManager(_: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.last else { return }
        Task { @MainActor in
            self.location = location
            // distances are in meters
            let rawDistance = location.distance(from: .recurse397)
            let minDistance = rawDistance - location.horizontalAccuracy
            nearRecurse397 = minDistance < 100
        }
    }
}
