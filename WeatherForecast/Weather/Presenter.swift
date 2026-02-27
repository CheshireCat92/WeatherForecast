//
//  Presenter.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import Foundation

protocol PresenterProtocol: AnyObject {
    func didFailWithError(error: String)
    func didFetchData(data: WeatherForecastResponse)
}

final class Presenter {
    weak var viewController: ViewControllerProtocol?
}

extension Presenter: PresenterProtocol {
    func didFailWithError(error: String) {
        viewController?.showError(message: error)
    }

    func didFetchData(data: WeatherForecastResponse) {
        // Format the response data for display
        let viewModel = "Weather: \(data.current.tempC)°C in \(data.location.name), \(data.location.region), \(data.location.country)"

        // Show the result to the View
        viewController?.displayData(viewModel: viewModel)
    }
}
