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
    let maxMinTemp: String

    init(city: String, feelsLike: String, current: String, maxMinTemp: String) {
        self.city = city
        self.feelsLike = feelsLike
        self.current = current
        self.maxMinTemp = maxMinTemp
    }
}
