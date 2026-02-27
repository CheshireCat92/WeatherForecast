//
//  CLLocationManager+Extensions.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 27.02.2026.
//

import Foundation
import CoreLocation


extension CLLocationManager {
    func isPermissionsGranted() -> Bool {
        switch self.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
}
