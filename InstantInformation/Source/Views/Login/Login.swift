//
//  Login.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-01.
//

import ComposableArchitecture

struct Login: ReducerProtocol {
	struct State: Equatable {}
	enum Action {
		case login
	}

	func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
		switch action {
		case .login:
			return .none
		}
	}
}
