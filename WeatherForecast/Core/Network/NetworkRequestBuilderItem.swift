//
//  NetworkRequestBuilderItem.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import Foundation

protocol NetworkRequestBuilderItem {
    var method: BaseRequestType {get}
    func path() -> String?
    func headers() -> [String: String]?
    func params() -> [String: String]?
    func bodyParams() -> (any Encodable)?
    func bodyDataType() -> BaseBodyDataType?
}
