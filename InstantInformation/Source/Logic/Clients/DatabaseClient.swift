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
    public var storeAuthentication: (Authentication) -> Void
    public var storeUser: (User) -> Void

    public init(
        getDidShowInitialAnimation: @escaping () -> Bool,
        setDidShowInitialAnimation: @escaping (Bool) -> Void,
        storeAuthentication: @escaping (Authentication) -> Void,
        storeUser: @escaping (User) -> Void
    ) {
        self.getDidShowInitialAnimation = getDidShowInitialAnimation
        self.setDidShowInitialAnimation = setDidShowInitialAnimation
        self.storeAuthentication = storeAuthentication
        self.storeUser = storeUser
    }
}

extension DatabaseClient: DependencyKey {
    public static let liveValue = DatabaseClient(
        getDidShowInitialAnimation: {
            Database.get(.didShowInitialAnimation)
        },
        setDidShowInitialAnimation: { value in
            Database.set(value, key: .didShowInitialAnimation)
        },
        storeAuthentication: { authentication in
            Database.set(authentication, key: .authentication)
        },
        storeUser: { user in
            Database.set(user, key: .user)
        }
    )
}

extension DatabaseClient: TestDependencyKey {
    public static let testValue = Self(
        getDidShowInitialAnimation: unimplemented("\(Self.self).getShowInitialAnimation"),
        setDidShowInitialAnimation: unimplemented("\(Self.self).setShowInitialAnimation"),
        storeAuthentication: unimplemented("\(Self.self).storeAuthentication"),
        storeUser: unimplemented("\(Self.self).storeUser")
    )

    public static let previewValue = Self(
        getDidShowInitialAnimation: { false },
        setDidShowInitialAnimation: { _ in },
        storeAuthentication: { _ in },
        storeUser: { _ in }
    )
}

extension DependencyValues {
    public var database: DatabaseClient {
        get { self[DatabaseClient.self] }
        set { self[DatabaseClient.self] = newValue }
    }
}
