//
//  WeatherNetworkService.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import Foundation

private enum Requests: NetworkRequestBuilderItem {
    func path() -> String? { nil }

    func headers() -> [String : String]? { nil }

    func bodyParams() -> (any Encodable)? { nil }

    func bodyDataType() -> BaseBodyDataType? { nil }

    case forecast(String, String)

    var method: BaseRequestType {
        switch self {
        case .forecast: .GET
        }
    }

    func params() -> [String: String]? {
        switch self {
        case let .forecast(lat, lon):
            return [
                "q": "\(lat),\(lon)"
            ]
        }
    }
}

protocol WeatherNetworkServiceProtocol {
    func fetchForecastDataFor(lat: String, lon: String) async -> WeatherForecastResponse?
}

final class WeatherNetworkService: BaseNetworkService, WeatherNetworkServiceProtocol {

    func fetchForecastDataFor(lat: String, lon: String) async -> WeatherForecastResponse? {
        
        guard let data: WeatherForecastResponse = await runRequest(request: Requests.forecast(lat, lon)) else {
            print("Failed to fetch forecast data")
            return nil
        }
        
        return data
    }

}
