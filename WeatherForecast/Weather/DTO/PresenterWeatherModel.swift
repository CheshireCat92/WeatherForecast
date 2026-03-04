//
//  PresenterWeatherModel.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 04.03.2026.
//

struct PresenterWeatherModel {
    let currentPlace: Location
    let currentDayWeather: ForecastDay?
    let currentWeather: CurrentWeather
    let hoursForecast: [HourWeather]
    let daysForecast: [ForecastDay]
}
