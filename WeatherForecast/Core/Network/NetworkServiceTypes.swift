//
//  NetworkServiceTypes.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

enum BaseRequestType: String {
    case POST, GET, PUT, PATCH, DELETE
}

enum BaseBodyDataType {
    case String, JSON
}

enum NetworkError: Error {
    case responseError(code: Int, message: String)
    case requestError(message: String)
    case decodeError
    case buildBaseRequestError
}
