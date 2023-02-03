//
//  LiveAPI.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-03.
//

import Foundation

struct LiveAPI: API {
    static let baseURLString = "https://live-api-url.com/"
    static let jsonDecoder: JSONDecoder = {
        var decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    static func request<T>(endpoint: Endpoint) async throws -> (data: T, response: URLResponse) where T: Decodable {
        guard let url = URL(string: Self.baseURLString + endpoint.path) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.string
        request.httpBody = try JSONSerialization.data(withJSONObject: endpoint.requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)
        let decodedData = try jsonDecoder.decode(T.self, from: data)
        return (decodedData, response)
    }
}
