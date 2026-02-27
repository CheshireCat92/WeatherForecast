//
//  BaseNetworkService.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import Foundation

class BaseNetworkService {
    private let coreNetwork: CoreNetworkServiceProtocol

    init(coreNetwork: CoreNetworkServiceProtocol) {
        self.coreNetwork = coreNetwork
    }

    func runRequest<T:Decodable>(request: NetworkRequestBuilderItem) async -> Result<T, NetworkError> {
        await coreNetwork.runRequest(item: request)
    }
}
