//
//  CoreLocationService.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 27.02.2026.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func locationDidUpdate(location: LocationDataModel)
    func locationDidError(_ error: LocationServiceErrors)
}

final class LocationService: NSObject {
    private let locationManager = CLLocationManager()
    weak var delegate: LocationServiceDelegate?

    override init() {
        super.init()
        setup()
    }

    private func setup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func start() {
        guard locationManager.isPermissionsGranted() else {
            locationManager.requestWhenInUseAuthorization()
            return
        }
    }

    func fetchCurrentLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.startUpdatingLocation()
    }

    func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        delegate?.locationDidUpdate(location: LocationDataModel(location: location))
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.isPermissionsGranted() {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        guard let error = error as? CLError else {
            delegate?.locationDidError(.someProblems)
            return
        }
        switch error.code {
        case .denied:
            delegate?.locationDidError(.permissionsNotGranted)
        default:
            delegate?.locationDidError(.someProblems)
        }
    }
}
