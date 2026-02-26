//
//  Interactor.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import Foundation

protocol InteractorProtocol: AnyObject {
    func fetchData(lat: String, lon: String) async
}

final class Interactor: InteractorProtocol {
    // MARK: - Types
    
    // MARK: - Properties
    weak var presenter: PresenterProtocol?
    private let networkService: WeatherNetworkServiceProtocol

    init(presenter: PresenterProtocol?, networkService: WeatherNetworkServiceProtocol) {
        self.presenter = presenter
        self.networkService = networkService
    }

    // MARK: - Business logic
    func fetchData(lat: String, lon: String) async {
        guard let response = await networkService.fetchForecastDataFor(lat: lat, lon: lon) else {
            presenter?.didFailWithError(error: "Failed to fetch weather data")
            return
        }
        
        presenter?.didFetchData(data: response)
    }
}
