//
//  CoreLocationService.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 27.02.2026.
//

import Foundation
import CoreLocation

final class LocationService: NSObject {
    private let locationManager = CLLocationManager()
    private var continuation: CheckedContinuation<LocationDataModel, any Error>?

    override init() {
        super.init()
        setup()
    }

    private func setup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        start()
    }

    private func start() {
        guard !locationManager.isPermissionsGranted() else { return }
        locationManager.requestWhenInUseAuthorization()
    }

    func fetchCurrentLocation() async throws-> LocationDataModel {
        guard continuation == nil else {
            throw LocationServiceErrors.someProblems
        }
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.continuation = continuation
            self?.locationManager.requestLocation()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        continuation?.resume(with: .success(LocationDataModel(location: location)))
        continuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        defer {
            continuation = nil
        }
        guard let error = error as? CLError else {
            continuation?.resume(with: .failure(LocationServiceErrors.someProblems))
            return
        }
        switch error.code {
        case .denied:
            continuation?.resume(with: .failure(LocationServiceErrors.permissionsNotGranted))
        default:
            continuation?.resume(with: .failure(LocationServiceErrors.someProblems))
        }
    }
}
