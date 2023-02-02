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
    }

    enum Action {
        case onAppear
        case welcome(Welcome.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state = .init()
                return .none

            default:
                return .none
            }
        }

        Scope(state: \.welcome, action: /Action.welcome) {
			Welcome()
        }
    }
}
