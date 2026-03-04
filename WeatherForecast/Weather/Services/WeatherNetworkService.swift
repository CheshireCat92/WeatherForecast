//
//  WeatherNetworkService.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import Foundation

private enum Requests: NetworkRequestBuilderItem {
    case forecast(lat: String, lon: String, days: Int?)

    func path() -> String? { nil }

    func headers() -> [String : String]? { nil }

    func bodyParams() -> (any Encodable)? { nil }

    func bodyDataType() -> BaseBodyDataType? { nil }

    var method: BaseRequestType {
        switch self {
        case .forecast: .GET
        }
    }

    func params() -> [String: String]? {
        switch self {
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
    func fetchForecastDataFor(lat: String, lon: String, days: Int) async -> Result<WeatherForecastResponse, WeatherNetworkServiceError>
}

final class WeatherNetworkService: BaseNetworkService, WeatherNetworkServiceProtocol {

    func fetchForecastDataFor(lat: String, lon: String, days: Int) async -> Result<WeatherForecastResponse, WeatherNetworkServiceError> {

        let result: Result<WeatherForecastResponse, NetworkError> = await runRequest(request: Requests.forecast(lat: lat, lon: lon, days: days))

        switch result {
        case .success(let data):
            return .success(data)
        case .failure(let error):
            switch error {
            case let .responseError(code, message):
                return .failure(.apiError(stausCode: code, message: message))
            default:
                return .failure(.coreError(message: error.localizedDescription))
            }
        }
    }

}
