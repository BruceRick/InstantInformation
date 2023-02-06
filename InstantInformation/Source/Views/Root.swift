//
//  Root.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-01.
//

import ComposableArchitecture

struct Root: ReducerProtocol {
    struct State: Equatable {
        var welcome = Welcome.State()
        var mainNavigation = MainNavigation.State()

        var user: User?
    }

    enum Action {
        case onAppear
        case welcome(Welcome.Action)
        case mainNavigation(MainNavigation.Action)
    }

    @Dependency(\.database) var database

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.user = database.getUser()
                return .none

            case .welcome(.complete(let user)):
                state.user = user
                return .none

            case .mainNavigation(.more(.selectMenuItem(.logout))):
                state.user = nil
                return .none

            case .mainNavigation:
                return .none

            case .welcome:
                return .none
            }
        }

        Scope(state: \.welcome, action: /Action.welcome) {
			Welcome()
        }

        Scope(state: \.mainNavigation, action: /Action.mainNavigation) {
            MainNavigation()
        }
    }
}
