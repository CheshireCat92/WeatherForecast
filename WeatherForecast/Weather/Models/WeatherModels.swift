//
//  WeatherModels.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import Foundation

// MARK: - Weather Forecast Response
struct WeatherForecastResponse: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

// MARK: - Current Weather
struct Current: Codable {
    let lastUpdatedEpoch: Int
    let lastUpdated: String
    let tempC: Double
    let tempF: Double
    let isDay: Int
    let condition: Condition
    let windMph: Double
    let windKph: Double
    let windDegree: Int
    let windDir: String
    let pressureMb: Int
    let pressureIn: Double
    let precipMm: Double
    let precipIn: Double
    let humidity: Int
    let cloud: Int
    let feelslikeC: Double
    let feelslikeF: Double
    let windchillC: Double
    let windchillF: Double
    let heatindexC: Double
    let heatindexF: Double
    let dewpointC: Double
    let dewpointF: Double
    let visKm: Int
    let visMiles: Int
    let uv: Double
    let gustMph: Double
    let gustKph: Double
}

// MARK: - Condition
struct Condition: Codable {
    let text: String
    let icon: String
    let code: Int
}

// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [Forecastday]
}

// MARK: - Forecastday
struct Forecastday: Codable {
    let date: String
    let dateEpoch: Int
    let day: Day
    let astro: Astro
    let hour: [Hour]
}

// MARK: - Day
struct Day: Codable {
    let maxtempC: Double
    let maxtempF: Double
    let mintempC: Double
    let mintempF: Double
    let avgtempC: Double
    let avgtempF: Double
    let maxwindMph: Double
    let maxwindKph: Double
    let totalprecipMm: Double
    let totalprecipIn: Double
    let totalsnowCm: Double
    let avgvisKm: Int
    let avgvisMiles: Int
    let avghumidity: Int
    let dailyWillItRain: Int
    let dailyChanceOfRain: Int
    let dailyWillItSnow: Int
    let dailyChanceOfSnow: Int
    let condition: Condition
    let uv: Double
}

// MARK: - Astro
struct Astro: Codable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let moonPhase: String
    let moonIllumination: Int
    let isMoonUp: Int
    let isSunUp: Int
}

// MARK: - Hour
struct Hour: Codable {
    let timeEpoch: Int
    let time: String
    let tempC: Double
    let tempF: Double
    let isDay: Int
    let condition: Condition
    let windMph: Double
    let windKph: Double
    let windDegree: Int
    let windDir: String
    let pressureMb: Int
    let pressureIn: Double
    let precipMm: Double
    let precipIn: Double
    let snowCm: Double
    let humidity: Int
    let cloud: Int
    let feelslikeC: Double
    let feelslikeF: Double
    let windchillC: Double
    let windchillF: Double
    let heatindexC: Double
    let heatindexF: Double
    let dewpointC: Double
    let dewpointF: Double
    let willItRain: Int
    let chanceOfRain: Int
    let willItSnow: Int
    let chanceOfSnow: Int
    let visKm: Int
    let visMiles: Int
    let gustMph: Double
    let gustKph: Double
    let uv: Double
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tzId: String
    let localtimeEpoch: Int
    let localtime: String

    enum CodingKeys: String, CodingKey {
        case tzId = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case name = "name"
        case region = "region"
        case country = "country"
        case lat = "lat"
        case lon = "lon"
        case localtime = "localtime"
    }
}
