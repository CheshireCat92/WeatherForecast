//
//  Network.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import Foundation

protocol CoreNetworkServiceProtocol {
    func runRequest<T: Decodable>(item: NetworkRequestBuilderItem) async -> Result<T,NetworkError>
    func runRequest<T: Decodable>(builder: NetworkRequestBuilderProtocol,item: NetworkRequestBuilderItem) async throws -> Result<T,NetworkError>

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

    func runRequest<T: Decodable>(item: NetworkRequestBuilderItem) async -> Result<T,NetworkError> {
        await self.runRequest(builder: defaultBuilder, item: item)
    }

    func runRequest<T: Decodable>(
        builder: NetworkRequestBuilderProtocol,
        item: NetworkRequestBuilderItem
    ) async -> Result<T,NetworkError> {
        var networkData: (data: Data, response: URLResponse)
        do {
            let request = try builder.buildFrom(item)
            networkData = try await session.data(for: request)
        } catch {
            if let networkError = error as? NetworkError {
                return Result.failure(networkError)
            }
            return Result.failure(NetworkError.requestError(message: error.localizedDescription))
        }

        if let error = checkError(networkData.response) {
            return Result.failure(error)
        }

        guard let result = try? JSONDecoder().decode(T.self, from: networkData.data) else {
            return Result.failure(NetworkError.decodeError)
        }
        return Result.success(result)
    }

    private func checkError(_ response: URLResponse) -> NetworkError? {
        guard let httpResponse = response as? HTTPURLResponse else { return nil }
        let positiveRange = 200..<300
        guard !positiveRange.contains(httpResponse.statusCode) else { return nil }
        return .responseError(code: httpResponse.statusCode, message: "")
    }

}
