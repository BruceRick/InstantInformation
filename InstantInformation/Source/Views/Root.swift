//
//  Root.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-01.
//

import ComposableArchitecture

struct Root: ReducerProtocol {
	enum Navigation {
		case welcome
		case login
		case createAccount
	}

    struct State: Equatable {
		var currentPage = Navigation.welcome

        var welcome = Welcome.State()
		var login = Login.State()
		var createAccount = CreateAccount.State()
    }

    enum Action {
        case onAppear
        case welcome(Welcome.Action)
		case login(Login.Action)
		case createAccount(CreateAccount.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state = .init()
                return .none

            case .welcome(.didTapLogin):
				state.currentPage = .login
				return .none

            case .welcome(.didTapCreateAccount):
				state.currentPage = .createAccount
				return .none

            default:
                return .none
            }
        }

        Scope(state: \.welcome, action: /Action.welcome) {
			Welcome()
        }

		Scope(state: \.login, action: /Action.login) {
			Login()
		}

		Scope(state: \.createAccount, action: /Action.createAccount) {
			CreateAccount()
		}
    }
}
