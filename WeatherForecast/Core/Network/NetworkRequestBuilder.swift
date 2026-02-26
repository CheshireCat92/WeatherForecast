//
//  NetworkRequestBuilder.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import Foundation

protocol NetworkRequestBuilderProtocol {
    func buildFrom(_ item: NetworkRequestBuilderItem) -> URLRequest?
}

final class NetworkRequestBuilder: NetworkRequestBuilderProtocol {

    func buildFrom(_ item: NetworkRequestBuilderItem) -> URLRequest? {
        guard var url = buildBaseUrlRequest() else { return nil }
        if let queries = item.params()?.keys.compactMap({ URLQueryItem(name: $0, value: item.params()?[$0]) }) {
            url.append(queryItems: queries)
        }
        var request = URLRequest(url: url)
        request.httpMethod = item.method.rawValue
        item.headers()?.forEach{
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        guard let bodyParams = item.bodyParams() else { return request }
        var data: Data?
        switch item.method {
        case .POST:
            switch item.bodyDataType() {
            case .String:
                if let stringData = bodyParams as? String {
                    data = Data(stringData.utf8)
                }
            case .JSON:
                data = try? JSONEncoder().encode(bodyParams)
            default:
                break
            }
            request.httpBody = data
        default:
            break;
        }

        return request
    }

    private func buildBaseUrlRequest() -> URL? {
        guard
            let baseUrlString = NetworkConstants.baseUrl,
            let key = NetworkConstants.apiKey,
            let paramName = NetworkConstants.apiKeyParamName,
            var url = URL(string: baseUrlString)
        else { return nil }
        let query = URLQueryItem(name: paramName, value: key)
        return url.appending(queryItems: [query])
    }
}
