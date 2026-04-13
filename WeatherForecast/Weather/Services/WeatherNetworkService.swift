//
//  WeatherNetworkService.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import Foundation

private enum Requests: NetworkRequestBuilderItem {
    case forecast(lat: String, lon: String, days: Int?)
    case current(lat: String, lon: String)

    func path() -> String? {
        switch self {
        case .forecast:
            return "/v1/forecast.json"
        case .current:
            return "/v1/current.json"
        }
    }

    func headers() -> [String : String]? { nil }

    func bodyParams() -> (any Encodable)? { nil }

    func bodyDataType() -> BaseBodyDataType? { nil }

    var method: BaseRequestType {
        switch self {
        case .forecast, .current: .GET
        }
    }

    func params() -> [String: String]? {
        switch self {
        case let .current(lat, lon):
            return [ "q": "\(lat),\(lon)" ]
        case let .forecast(lat, lon, days):
            var params = [ "q": "\(lat),\(lon)" ]
            if let days = days {
                params["days"] = "\(days)"
            }
            return params
        }
    }
}

enum WeatherNetworkServiceError: Error {
    case apiError(stausCode: Int, message: String)
    case coreError(message: String)
}

protocol WeatherNetworkServiceProtocol {
    func fetchForecastDataFor(lat: String, lon: String, days: Int) async throws(WeatherNetworkServiceError) -> WeatherForecastResponse
    func fetchCurrentDataFor(lat: String, lon: String) async throws(WeatherNetworkServiceError) -> WeatherForecastResponse
}

final class WeatherNetworkService: BaseNetworkService, WeatherNetworkServiceProtocol {

    func fetchForecastDataFor(lat: String, lon: String, days: Int) async throws(WeatherNetworkServiceError) -> WeatherForecastResponse {
        do {
            return try await runRequest(Requests.forecast(lat: lat, lon: lon, days: days))
        } catch {
            switch error {
                case let .responseError(code, message):
                    throw .apiError(stausCode: code, message: message)
                default:
                    throw .coreError(message: error.localizedDescription)
            }
        }
    }

    func fetchCurrentDataFor(lat: String, lon: String) async throws(WeatherNetworkServiceError) -> WeatherForecastResponse {
        do {
            return try await runRequest(Requests.current(lat: lat, lon: lon))
        } catch {
            switch error {
                case let .responseError(code, message):
                    throw .apiError(stausCode: code, message: message)
                default:
                    throw .coreError(message: error.localizedDescription)
            }
        }
    }

}
