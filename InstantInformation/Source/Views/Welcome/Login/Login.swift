//
//  Login.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-01.
//

import ComposableArchitecture

struct Login: ReducerProtocol {
	struct State: Equatable {
        @BindingState var username: String = ""
        @BindingState var password: String = ""
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
	}

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { _, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}
