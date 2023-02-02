//
//  Welcome.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-01.
//

import ComposableArchitecture

struct Welcome: ReducerProtocol {
	enum AnimationStep {
		case logo
		case items
		case getStarted
	}

    struct State: Equatable {
        let items = ["News", "Entertainment", "Sports", "Friends", "Family", "Safety", "Privacy"]

		var completedAnimations: [AnimationStep] = []
        var shownItems: [String] = []
    }

    enum Action {
		case animate(AnimationStep)
		case stepCompleted(AnimationStep)
        case showItem(String)
		case showItems([String])
		case didTapCreateAccount
		case didTapLogin
    }

    @Dependency(\.continuousClock) var clock

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        enum CancelID {}

		switch action {
		case .animate(.logo):
			return .run { send in
				await send(.stepCompleted(.logo), animation: .easeIn(duration: 2.0))
				try await self.clock.sleep(for: .seconds(2))
				await send(.animate(.items), animation: .easeIn(duration: 2.0))
			}
			.cancellable(id: CancelID.self)

		case .animate(.items):
			let items = state.items
			return .run { send in
				for text in items {
					await send(.showItem(text), animation: .easeIn(duration: 0.5))
					try await self.clock.sleep(for: .seconds(0.5))
				}

				await send(.showItems([""]), animation: .easeIn(duration: 0.5))
				try await self.clock.sleep(for: .seconds(2.0))

				await send(.showItems(["Information"]), animation: .easeIn(duration: 0.5))
				try await self.clock.sleep(for: .seconds(0.5))

				await send(.stepCompleted(.items))
				await send(.animate(.getStarted))
			}
			.cancellable(id: CancelID.self)

		case .animate(.getStarted):
			return .run { send in
				try await self.clock.sleep(for: .seconds(1.0))
				await send(.stepCompleted(.getStarted), animation: .easeIn(duration: 1.0))
			}
			.cancellable(id: CancelID.self)

		case .stepCompleted(let step):
			state.completedAnimations.append(step)
			return .none

		case .showItem(let text):
            state.shownItems.append(text)
            return .none

		case .showItems(let items):
			state.shownItems = items
			return .none

		case .didTapGetStarted:
            return .none
        }
    }
}
