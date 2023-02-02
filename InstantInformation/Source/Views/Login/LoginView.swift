//
//  LoginView.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-01.
//

import ComposableArchitecture
import SwiftUI

struct LoginView: View {
	let store: StoreOf<Login>

	var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			Content(store: viewStore)
		}
	}
}

private extension LoginView {
	struct Content: View {
		let store: ViewStoreOf<Login>
	}
}

private extension LoginView.Content {
	@ViewBuilder
	var body: some View {
		Text("Login")
	}
}
