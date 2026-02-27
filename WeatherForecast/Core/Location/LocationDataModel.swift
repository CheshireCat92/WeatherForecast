//
//  LocationData.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 27.02.2026.
//

import Foundation
import CoreLocation

struct LocationDataModel: Equatable {
    let lat: Double
    let lon: Double

    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }

    init(location: CLLocation) {
        self.lat = location.coordinate.latitude
        self.lon = location.coordinate.longitude
    }
}
