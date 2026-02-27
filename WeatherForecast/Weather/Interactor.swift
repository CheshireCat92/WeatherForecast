//
//  Interactor.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import Foundation

protocol InteractorProtocol: AnyObject {
    func fetchData(lat: String, lon: String) async
    func fetchLocation() async
}

final class Interactor: InteractorProtocol {
    // MARK: - Constants
    private enum Constants {
        static let defaultLocation = LocationDataModel(lat: 55.751244, lon: 37.618423)
    }

    // MARK: - Properties
    private var presenter: PresenterProtocol?
    private let networkService: WeatherNetworkServiceProtocol
    private let locationService: LocationService
    private var lastKnownLocation: LocationDataModel? = nil

    init(
        presenter: PresenterProtocol?,
        networkService: WeatherNetworkServiceProtocol,
        locationService: LocationService
    ) {
        self.presenter = presenter
        self.networkService = networkService
        self.locationService = locationService
        setup()
    }

    private func setup() {
        locationService.delegate = self
        locationService.start()
    }

    // MARK: - Business logic
    func fetchLocation() {
        locationService.fetchCurrentLocation()
    }

    func fetchData(lat: String, lon: String) async {
        let response = await networkService.fetchForecastDataFor(lat: lat, lon: lon)

        switch response {
        case .success(let data):
            presenter?.didFetchData(data: data)
        case .failure(let error):
            presenter?.didFailWithError(error: error.localizedDescription)
        }
    }
}

extension Interactor: LocationServiceDelegate {

    func locationDidError(_ error: LocationServiceErrors) {

        Task { [weak self] in
            guard let self else { return }
            let lastLocation = self.lastKnownLocation ?? Constants.defaultLocation
            await self.fetchData(
                lat: "\(lastLocation.lat)",
                lon: "\(lastLocation.lon)"
            )
        }
    }
    
    func locationDidUpdate(location: LocationDataModel) {
        guard lastKnownLocation != location else { return }
        lastKnownLocation = location
        Task { [weak self, location] in
            await self?.fetchData(
                lat: "\(location.lat)",
                lon: "\(location.lon)"
            )
        }
    }
}
