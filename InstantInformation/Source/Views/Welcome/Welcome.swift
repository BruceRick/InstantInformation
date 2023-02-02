//
//  Welcome.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-01.
//

import ComposableArchitecture

struct Welcome: ReducerProtocol {
    struct State: Equatable {
        let items = ["News", "Entertainment", "Sports", "Friends", "Family", "Safety", "Privacy"]

        var completedAnimations: [AnimationStep] = []
        var shownItems: [String] = []

        var contentShown: Content = .createAccount

        var login = Login.State()
        var createAccount = CreateAccount.State()

        var showAnimation = false
    }

    enum Action {
        case onAppear
		case animate(AnimationStep)
		case stepCompleted(AnimationStep)
        case showItem(String)
		case showItems([String])
		case showContent(Content)
        case performLogin
        case performAccountCreation

        case login(Login.Action)
        case createAccount(CreateAccount.Action)
    }

    enum AnimationStep: CaseIterable {
        case logo
        case items
        case showContent
    }

    enum Content {
        case createAccount
        case login
    }

    @Dependency(\.continuousClock) var clock
    @Dependency(\.database) var database

    enum CancelID {}

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let showAnimation = !database.getDidShowInitialAnimation()
                state.completedAnimations = showAnimation ? [] : AnimationStep.allCases
                return showAnimation ? .init(value: .animate(.logo)) : .none

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
                    try await self.clock.sleep(for: .seconds(1.0))

                    await send(.showItems(["Information"]), animation: .easeIn(duration: 0.5))
                    try await self.clock.sleep(for: .seconds(0.5))

                    await send(.stepCompleted(.items))
                    await send(.animate(.showContent))
                }
                .cancellable(id: CancelID.self)

            case .animate(.showContent):
                return .run { send in
                    try await self.clock.sleep(for: .seconds(1.0))
                    await send(.stepCompleted(.showContent), animation: .easeIn(duration: 1.0))
                    self.database.setDidShowInitialAnimation(true)
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

            case .showContent(let content):
                state.contentShown = content
                return .none

            case .performLogin:
                return .none

            case .performAccountCreation:
                return .none

            case .login:
                return .none

            case .createAccount:
                return .none
            }
        }
    }
}
