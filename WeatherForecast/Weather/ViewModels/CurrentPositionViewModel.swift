//
//  CurrentPositionViewModel.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 04.03.2026.
//

struct CurrentPositionViewModel {
    let city: String
    let feelsLike: String
    let current: String
    let minTemp: String
    let maxTemp: String

    init(city: String, feelsLike: String, current: String, minTemp: String, maxTemp: String) {
        self.city = city
        self.feelsLike = feelsLike
        self.current = current
        self.minTemp = minTemp
        self.maxTemp = maxTemp
    }
}
