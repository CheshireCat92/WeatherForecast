//
//  NetworkConstants.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//
import Foundation

enum NetworkConstants {
    static var apiKey: String? {
        Bundle.main.infoDictionary?["API_KEY"] as? String
    }

    static var apiKeyParamName: String? {
        Bundle.main.infoDictionary?["API_KEY_PARAM_NAME"] as? String
    }

    static var baseUrl: String? {
        Bundle.main.infoDictionary?["BASE_URL"] as? String
    }
}
