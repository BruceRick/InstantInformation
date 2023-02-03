//
//  MockAPI.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-03.
//

import Foundation

struct MockAPI: API {
    static let baseURLString = "https://mocke-api-url.com/"
    static let throttleDurationSeconds = 2

    static func request<T>(endpoint: Endpoint) async throws -> (data: T, response: URLResponse) where T: Decodable {
        try await Task.sleep(nanoseconds: throttleDurationNanosecond)

        guard let url = URL(string: Self.baseURLString + endpoint.path) else {
            throw APIError.invalidURL
        }

        guard let mock = endpoint.mock as? T else {
            throw APIError.invalidURL
        }

        return (mock, .init(url: url,
                            mimeType: "mockMIME",
                            expectedContentLength: 100,
                            textEncodingName: "MockTextEndcoding"))
    }
}

private extension Endpoint {
    var mock: Decodable {
        switch self {
        case .login, .register:
            return Authentication(accessToken: "MOCK ACCESS TOKEN", refreshToken: "MOCK REFRESH TOKEN")
        case .user:
            return User(name: "Bruce Rick", username: "brick")
        }
    }
}

extension MockAPI {
  static let nanosecondMultiplier = 1_000_000_000
  static var throttleDurationNanosecond: UInt64 { UInt64(throttleDurationSeconds * nanosecondMultiplier) }
}
