//
//  DailyForecastViewModel.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 04.03.2026.
//

import Foundation

struct DailyForecastViewModel {
    let forecast: [DayViewModel]
}

struct DayViewModel {
    let isCurrentDay: Bool
    let day: String
    let imageURL: URL?
    let minTemp: String
    let maxTemp: String
}
