//
//  HoursForecastViewModel.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 04.03.2026.
//

import Foundation

struct HoursForecastViewModel {
    let forecast: [HourViewModel]
}

struct HourViewModel {
    let isNow: Bool
    let isNextDayStart: Bool
    let time: String
    let temperature: String
    let imageURL: URL?
}
