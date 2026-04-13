//
//  Network.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import Foundation

protocol CoreNetworkServiceProtocol {
    func runRequest<T: Decodable>(item: NetworkRequestBuilderItem) async throws(NetworkError)-> T
    func runRequest<T: Decodable>(builder: NetworkRequestBuilderProtocol,item: NetworkRequestBuilderItem) async throws(NetworkError) -> T

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

    func runRequest<T: Decodable>(item: NetworkRequestBuilderItem) async throws(NetworkError) -> T {
        try await self.runRequest(builder: defaultBuilder, item: item)
    }

    func runRequest<T: Decodable>(
        builder: NetworkRequestBuilderProtocol,
        item: NetworkRequestBuilderItem
    ) async throws(NetworkError) -> T {
        var networkData: (data: Data, response: URLResponse)
        do {
            let request = try builder.buildFrom(item)
            networkData = try await session.data(for: request)
        } catch {
            guard let networkError = error as? NetworkError else {
                throw .requestError(message: error.localizedDescription)
            }
            throw networkError
        }

        if let error = checkError(networkData.response) {
            throw error
        }

        do {
            return try JSONDecoder().decode(T.self, from: networkData.data)
        } catch {
            throw .decodeError(message: error.localizedDescription)
        }
    }

    private func checkError(_ response: URLResponse) -> NetworkError? {
        guard let httpResponse = response as? HTTPURLResponse else { return nil }
        let positiveRange = 200..<300
        guard !positiveRange.contains(httpResponse.statusCode) else { return nil }
        return .responseError(code: httpResponse.statusCode, message: "")
    }

}
