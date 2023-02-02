//
//  WelcomeView.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-01.
//

import ComposableArchitecture
import SwiftUI

struct WelcomeView: View {
    let store: StoreOf<Welcome>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Content(store: store, viewStore: viewStore)
        }
    }
}

private extension WelcomeView {
    struct Content: View {
        let store: StoreOf<Welcome>
        let viewStore: ViewStoreOf<Welcome>
    }
}

private extension WelcomeView.Content {
	@ViewBuilder
    var body: some View {
		VStack {
			if viewStore.completedAnimations.contains(.logo) {
                Logo()
                    .transition(.opacity)
                    .zIndex(100)
                    .background(Color.white)
			}

            if viewStore.completedAnimations.contains(.logo) &&
                !viewStore.completedAnimations.contains(.showContent) {
                HStack(alignment: .top, spacing: 0) {
                    leftText
                    items
                }.padding(.bottom, 10)
                Spacer()
            }

			if viewStore.completedAnimations.contains(.showContent) {
				content
			}
		}.onAppear { viewStore.send(.animate(.logo)) }
    }

	var leftText: some View {
		Text("ii. Instant ")
			.fontWeight(.bold)
			.frame(maxWidth: .infinity, alignment: .trailing)
			.transition(.opacity)
	}

	var items: some View {
		VStack(alignment: .leading) {
			ForEach(Array(viewStore.shownItems.enumerated()), id: \.offset) { index, text in
				Text(text)
					.fontWeight(.bold)
					.zIndex(Double(-index))
					.frame(maxWidth: .infinity, alignment: .leading)
					.background(Color.white)
			}
		}
		.frame(maxWidth: .infinity, alignment: .trailing)
	}

	var switchContentText: some View {
		Text(switchContentString)
	}

	var switchContentButton: some View {
		Button {
            let content: Welcome.Content = viewStore.contentShown == .login ? .createAccount : .login
            viewStore.send(.showContent(content), animation: .linear)
		} label: {
			ZStack {
				Text(switchContentButtonString)
					.fontWeight(.bold)
					.frame(alignment: .center)
				Image(systemName: "chevron.right")
					.fontWeight(.bold)
					.frame(maxWidth: .infinity, alignment: .trailing)
			}.frame(maxWidth: .infinity)
		}
		.padding()
		.foregroundColor(.black)
		.overlay(
			RoundedRectangle(cornerRadius: 26)
				.stroke(.black, lineWidth: 2)
		)
		.padding()
		.transition(.opacity)
	}

	var actionButton: some View {
		Button {
            let action: Welcome.Action = viewStore.contentShown == .login ? .performAccountCreation : .performLogin
            viewStore.send(action, animation: .linear)
		} label: {
			Text(actionButtonString)
				.fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
		}
		.padding()
		.frame(maxWidth: .infinity)
		.foregroundColor(.white)
		.background(Color.black)
		.clipShape(Capsule())
		.padding()
		.transition(.opacity)
	}

    @ViewBuilder
    var content: some View {
        if viewStore.contentShown == .login {
            LoginView(store: store.scope(
                state: \.login,
                action: Welcome.Action.login
            ))
        } else {
            CreateAccountView(store: store.scope(
                state: \.createAccount,
                action: Welcome.Action.createAccount
            ))
        }
        Spacer()
        actionButton
        switchContentText
        switchContentButton
    }

    var actionButtonString: String {
        viewStore.contentShown == .login ? "Login" : "Create Account"
    }

    var switchContentString: String {
        viewStore.contentShown == .login ? "Don't have an account?" : "Have an account already?"
    }

    var switchContentButtonString: String {
        viewStore.contentShown == .login ? "Create an Account" : "Continue to Login"
    }
}

// MARK: - SwiftUI previews

struct WelcomeView_Previews: PreviewProvider {
  static var previews: some View {
      WelcomeView(store: Store(initialState: Welcome.State(), reducer: Welcome()))
  }
}
