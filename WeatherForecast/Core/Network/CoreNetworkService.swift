//
//  Network.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import Foundation

protocol CoreNetworkServiceProtocol {
    func runRequest<T>(item: NetworkRequestBuilderItem) async throws -> T? where T:Decodable
    func runRequest<T>(builder: NetworkRequestBuilderProtocol,item: NetworkRequestBuilderItem) async throws -> T? where T:Decodable

}

final class CoreNetworkService: CoreNetworkServiceProtocol {
    private let configuration = URLSessionConfiguration.default
    private let session: URLSession
    private let defaultBuilder = NetworkRequestBuilder()

    init() {
        configuration.timeoutIntervalForRequest = 30.0
        configuration.allowsCellularAccess = true
        configuration.waitsForConnectivity = true
        self.session = URLSession(configuration: configuration)
    }

    func runRequest<T>(item: NetworkRequestBuilderItem) async throws -> T? where T:Decodable {
        return try? await self.runRequest(builder: defaultBuilder, item: item)
    }

    func runRequest<T>(
        builder: NetworkRequestBuilderProtocol,
        item: NetworkRequestBuilderItem
    ) async throws -> T? where T:Decodable {
        guard let request = builder.buildFrom(item) else { return nil }
        let (data, response) = try await session.data(for: request)
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            print("Can't parse model")
            return nil
        }
        return result
    }

}
