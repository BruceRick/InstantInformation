//
//  CreateAccountView.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-02.
//

import ComposableArchitecture
import SwiftUI

struct CreateAccountView: View {
	let store: StoreOf<CreateAccount>

	var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			Content(store: viewStore)
		}
	}
}

private extension CreateAccountView {
	struct Content: View {
        let store: ViewStore<CreateAccount.State, CreateAccount.Action>
	}
}

private extension CreateAccountView.Content {
	@ViewBuilder
	var body: some View {
        VStack {
            Text("Create your account")
                .fontWeight(.bold)
            TextInput(placeHolder: "Email", text: store.binding(\.$email))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            TextInput(placeHolder: "Username", text: store.binding(\.$username))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            TextInput(placeHolder: "Password", text: store.binding(\.$password), isSecure: true)
            TextInput(placeHolder: "Confirm Password", text: store.binding(\.$confirmPassword), isSecure: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
	}
}

// MARK: - SwiftUI previews

struct CreateAccountView_Previews: PreviewProvider {
  static var previews: some View {
      CreateAccountView(store: Store(initialState: CreateAccount.State(), reducer: CreateAccount()))
  }
}
