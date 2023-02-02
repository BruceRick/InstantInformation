//
//  RootView.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-01.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: StoreOf<Root>

    var body: some View {
        content
            .onAppear { ViewStore(self.store).send(.onAppear) }
    }

    var content: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			switch viewStore.currentPage {
			case .welcome:
				WelcomeView(store: self.store.scope(
					state: \.welcome,
					action: Root.Action.welcome
				))
			case .login:
				LoginView(store: self.store.scope(
					state: \.login,
					action: Root.Action.login
				))
			case .createAccount:
				CreateAccountView(store: self.store.scope(
					state: \.createAccount,
					action: Root.Action.createAccount
				))
			}
		}
    }
}
