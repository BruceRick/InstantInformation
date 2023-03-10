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
        VStack(spacing: 0) {
            if viewStore.completedAnimations.contains(.logo) {
                Logo()
                    .transition(.opacity)
                    .zIndex(100)
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
		}
        .onAppear { viewStore.send(.onAppear) }
        .padding(.horizontal, 20)
        .overlay {
            if viewStore.loading {
                ZStack(alignment: .center) {
                    Color.black.opacity(0.75)
                    VStack {
                        Spacer()
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        Spacer()
                    }
                }.ignoresSafeArea()
            } else {
                EmptyView()
            }
        }
    }

	var leftText: some View {
		Text("ii. Instant ")
			.fontWeight(.bold)
			.frame(maxWidth: .infinity, alignment: .trailing)
			.transition(.opacity)
            .foregroundColor(.gray)
	}

	var items: some View {
		VStack(alignment: .leading) {
			ForEach(Array(viewStore.shownItems.enumerated()), id: \.offset) { index, text in
				Text(text)
					.fontWeight(.bold)
					.zIndex(Double(-index))
					.frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.gray)
					.background(Color.white)
			}
		}
		.frame(maxWidth: .infinity, alignment: .trailing)
	}

	var switchContentText: some View {
		Text(switchContentString)
            .fontWeight(.medium)
            .foregroundColor(.gray)
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
		.foregroundColor(.blue)
		.overlay(
			RoundedRectangle(cornerRadius: 26)
				.stroke(.blue, lineWidth: 2)
		)
		.padding()
		.transition(.opacity)
	}

	var actionButton: some View {
		Button {
            let action: Welcome.Action = viewStore.contentShown == .login ? .registerRequest : .loginRequest
            viewStore.send(action, animation: .linear)
		} label: {
			Text(actionButtonString)
				.fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
		}
		.padding()
		.frame(maxWidth: .infinity)
		.foregroundColor(.white)
		.background(Color.blue)
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
            .padding(20)
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.systemGray5), lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        } else {
            CreateAccountView(store: store.scope(
                state: \.createAccount,
                action: Welcome.Action.createAccount
            ))
            .padding(20)
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.systemGray5), lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
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
