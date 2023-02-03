//
//  NetworkClient.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-02.
//

import Dependencies
import Foundation
import XCTestDynamicOverlay

public struct NetworkClient {
    public var api: () -> API.Type

    public init(
        api: @escaping () -> API.Type
    ) {
        self.api = api
    }
}

extension NetworkClient: DependencyKey {
    public static let liveValue = Self(
        // api: { LiveAPI.self }
        api: { MockAPI.self }
    )
}

extension NetworkClient: TestDependencyKey {
    public static let testValue = Self(
        api: unimplemented("\(Self.self).getShowInitialAnimation")
    )

    public static let previewValue = Self(
        api: { MockAPI.self }
    )

    public static let mock = Self(
        api: { MockAPI.self }
    )
}

extension DependencyValues {
    public var networkClient: NetworkClient {
        get { self[NetworkClient.self] }
        set { self[NetworkClient.self] = newValue }
    }
}
