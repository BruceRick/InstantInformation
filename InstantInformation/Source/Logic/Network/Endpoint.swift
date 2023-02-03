//
//  Endpoint.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-03.
//

import Foundation

public enum Endpoint {
    case login(username: String, password: String)
    case register(username: String, email: String, password: String)
    case user

    var path: String {
        switch self {
        case .login:
            return "auth/login"
        case .register:
            return "register"
        case .user:
            return "user"
        }
    }

    var requestBody: [String: Any] {
        switch self {
        case let .login(username, password):
            return ["username": username, "password": password]
        case let .register(username, email, password):
            return ["username": username, "email": email, "password": password]
        default:
            return [:]
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .login:
            return .post
        default:
            return .get
        }
    }
}

enum HTTPMethod {
    case get
    case post

    var string: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}
