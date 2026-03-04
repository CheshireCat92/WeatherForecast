//
//  Interactor.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import Foundation

protocol InteractorProtocol: AnyObject {
//    func fetchData(lat: String, lon: String) async
    func fetchLocation() async
}

final class Interactor: InteractorProtocol {
    // MARK: - Constants
    private enum Constants {
        static let defaultLocation = LocationDataModel(lat: 55.751244, lon: 37.618423)
        static let defaultDaysCount = 3
        static let defaultHourForecastDays = 2
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

    private func fetchData(lat: String, lon: String, days: Int = Constants.defaultDaysCount) async {
        let response = await networkService.fetchForecastDataFor(lat: lat, lon: lon, days: days)

        switch response {
        case .success(let data):
            await presenter?.didFetchData(data: processResponse(data))
        case .failure(let error):
            await presenter?.didFailWithError(error: error.localizedDescription)
        }
    }

    private func processResponse(_ response: WeatherForecastResponse) -> PresenterWeatherModel {
        let model = PresenterWeatherModel(
            currentPlace: response.location,
            currentDayWeather: response.forecast?.forecastday.first,
            currentWeather: response.current,
            hoursForecast: processHourForecast(response)
        )
        return model
    }

    private func processHourForecast(_ response: WeatherForecastResponse) -> [HourWeather] {
        guard let date = Date.now.timeStampWithComponents([.year,.month,.day,.hour]) else {
            return [HourWeather]()
        }
        var dropOffset = 0
        let data = response.forecast?.forecastday.prefix(Constants.defaultHourForecastDays).flatMap {
            $0.hour
        }.enumerated().compactMap{
            let dayEphoche = TimeInterval($0.element.timeEpoch)
            guard dayEphoche >= date else {
                dropOffset = $0.offset + 1
                return nil
            }
            return $0.element
        } ?? [HourWeather]()
        return data.dropLast(dropOffset)
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
