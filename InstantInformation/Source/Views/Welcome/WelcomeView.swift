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
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Content(store: viewStore)
        }
    }
}

private extension WelcomeView {
    struct Content: View {
        let store: ViewStoreOf<Welcome>
    }
}

private extension WelcomeView.Content {

	@ViewBuilder
    var body: some View {
		VStack {
			if store.completedAnimations.contains(.logo) {
				logo
			}

			HStack(alignment: .top, spacing: 0) {
				if store.completedAnimations.contains(.logo) {
					text
				}
				if store.completedAnimations.contains(.logo) {
					items
				}
			}.padding(.bottom, 10)

			if store.completedAnimations.contains(.getStarted) {
				createAccountButton
				loginText
				loginButton
			}
			Spacer()
		}.onAppear { store.send(.animate(.logo)) }
    }

	var logo: some View {
		Image("logo")
			.resizable()
			.aspectRatio(contentMode: .fit)
			.frame(width: 150, height: 150)
			.padding(.top, 100)
			.padding(.bottom, 20)
			.transition(.opacity)
			.zIndex(100)
			.background(Color.white)
	}

	var text: some View {
		Text("ii. Instant ")
			.fontWeight(.bold)
			.frame(maxWidth: .infinity, alignment: .trailing)
			.transition(.opacity)
	}

	var items: some View {
		VStack(alignment: .leading) {
			ForEach(Array(store.shownItems.enumerated()), id: \.offset) { index, text in
				Text(text)
					.fontWeight(.bold)
					.zIndex(Double(-index))
					.frame(maxWidth: .infinity, alignment: .leading)
					.transition(.move(edge: .top))
					.background(Color.white)
			}
		}
		.frame(maxWidth: .infinity, alignment: .trailing)
	}

	var loginText: some View {
		Text("Have an account already?")
	}

	var loginButton: some View {
		Button {
			store.send(.didTapLogin)
		} label: {
			ZStack {
				Text("Continue To Login")
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

	var createAccountButton: some View {
		Button {
			store.send(.didTapCreateAccount)
		} label: {
			Text("Create Account")
				.fontWeight(.bold)
				.frame(alignment: .center)
		}
		.padding()
		.frame(maxWidth: .infinity)
		.foregroundColor(.white)
		.background(Color.blue)
		.clipShape(Capsule())
		.padding()
		.transition(.opacity)
	}
}

// MARK: - SwiftUI previews

struct WelcomeView_Previews: PreviewProvider {
  static var previews: some View {
      WelcomeView(store: Store(initialState: Welcome.State(), reducer: Welcome()))
  }
}
