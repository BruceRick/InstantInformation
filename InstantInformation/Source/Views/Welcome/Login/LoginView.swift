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
        VStack(spacing: 10) {
            Text("Login")
                .fontWeight(.bold)
                .foregroundColor(.gray)
            TextInput(placeHolder: "Username", text: store.binding(\.$username))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            TextInput(placeHolder: "Password", text: store.binding(\.$password), isSecure: true)
        }
        .frame(maxWidth: .infinity)
	}
}
