//
//  DatabaseClient.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-02.
//

import Dependencies
import Foundation
import XCTestDynamicOverlay

public struct DatabaseClient {
    public var getDidShowInitialAnimation: () -> Bool
    public var setDidShowInitialAnimation: (Bool) -> Void

    public init(
        getDidShowInitialAnimation: @escaping () -> Bool,
        setDidShowInitialAnimation: @escaping (Bool) -> Void
    ) {
        self.getDidShowInitialAnimation = getDidShowInitialAnimation
        self.setDidShowInitialAnimation = setDidShowInitialAnimation
    }
}

extension DatabaseClient: DependencyKey {
    public static let liveValue = DatabaseClient(
        getDidShowInitialAnimation: {
            Database.get(.didShowInitialAnimation)
        },
        setDidShowInitialAnimation: { value in
            Database.set(value, key: .didShowInitialAnimation)
        }
    )
}

extension DatabaseClient: TestDependencyKey {
    public static let testValue = Self(
        getDidShowInitialAnimation: unimplemented("\(Self.self).getShowInitialAnimation"),
        setDidShowInitialAnimation: unimplemented("\(Self.self).setShowInitialAnimation")
    )

    public static let previewValue = Self(
        getDidShowInitialAnimation: { false },
        setDidShowInitialAnimation: { _ in }
    )
}

extension DependencyValues {
    public var database: DatabaseClient {
        get { self[DatabaseClient.self] }
        set { self[DatabaseClient.self] = newValue }
    }
}
