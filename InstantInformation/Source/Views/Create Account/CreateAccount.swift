//
//  CreateAccount.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-02.
//

import ComposableArchitecture

struct CreateAccount: ReducerProtocol {
	struct State: Equatable {
        @BindingState var focusedField: Field?
        @BindingState var email: String = ""
        @BindingState var username: String = ""
        @BindingState var password: String = ""
        @BindingState var confirmPassword: String = ""
    }

    enum Field {
        case email
        case username
        case password
        case confirmPassword
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
		case createAccount
	}

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { _, action in
            switch action {
            case .binding:
                return .none

            case .createAccount:
                return .none
            }
        }
    }
}
