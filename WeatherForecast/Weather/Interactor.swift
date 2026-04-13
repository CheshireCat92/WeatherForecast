//
//  Interactor.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import Foundation

protocol InteractorProtocol: AnyObject {
    func fetchLocation()
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
        Task {
            await presenter?.updateInfoState(.initial)
        }
    }

    // MARK: - Business logic
    func fetchLocation() {
        Task {
            await presenter?.updateInfoState(.loading)
            do {
                let data = try await locationService.fetchCurrentLocation()
                await locationDidUpdate(location: data)
            } catch {
                await locationDidError(error as! LocationServiceErrors)
            }
        }
    }

    private func locationDidError(_ error: LocationServiceErrors) async {
        let lastLocation = self.lastKnownLocation ?? Constants.defaultLocation
        await fetchData(
            lat: "\(lastLocation.lat)",
            lon: "\(lastLocation.lon)",
        )
    }

    private func locationDidUpdate(location: LocationDataModel) async {
        lastKnownLocation = location
        await fetchData(
            lat: "\(location.lat)",
            lon: "\(location.lon)"
        )
    }

    private func fetchData(lat: String, lon: String, days: Int = Constants.defaultDaysCount) async {
        async let forecastAsync = networkService.fetchForecastDataFor(lat: lat, lon: lon, days: days)
        async let currentAsync = networkService.fetchCurrentDataFor(lat: lat, lon: lon)

        do {
            let data = try await processResponse(forecast: forecastAsync, current: currentAsync)
            await presenter?.didFetchData(data: data)
        } catch {
            await presenter?.didFailWithError(error: error.localizedDescription)
        }
    }

    private func processResponse(forecast: WeatherForecastResponse, current: WeatherForecastResponse) -> PresenterWeatherModel {
        PresenterWeatherModel(
            currentPlace: current.location,
            currentDayWeather: forecast.forecast?.forecastday.first,
            currentWeather: current.current,
            hoursForecast: processHourForecast(forecast),
            daysForecast: forecast.forecast?.forecastday ?? [ForecastDay]()
        )
    }

    private func processHourForecast(_ response: WeatherForecastResponse) -> [HourWeather] {
        guard let date = Date.now.timeStampWithComponents([.year,.month,.day,.hour]) else {
            return [HourWeather]()
        }
        let data = response.forecast?.forecastday
            .prefix(Constants.defaultHourForecastDays)
            .flatMap(\.hour)
            .filter{
                TimeInterval($0.timeEpoch) >= date
            }
        return data ?? [HourWeather]()
    }
}
