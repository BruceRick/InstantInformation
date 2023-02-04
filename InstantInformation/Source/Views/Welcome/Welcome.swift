//
//  Welcome.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-01.
//

import Foundation
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
        var loading = false
    }

    enum Action {
        case onAppear
		case animate(AnimationStep)
		case stepCompleted(AnimationStep)
        case showItem(String)
		case showItems([String])
		case showContent(Content)

        case loginRequest
        case registerRequest
        case userRequest
        case loginResponse(TaskResult<(data: Authentication, response: URLResponse)>)
        case registerResponse(TaskResult<(data: Authentication, response: URLResponse)>)
        case userResponse(TaskResult<(data: User, response: URLResponse)>)

        case complete(User)

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
    @Dependency(\.networkClient.api) var api

    enum CancelID {}
    enum LoginCancelID {}
    enum RegisterCancelID {}
    enum UserCancelID {}

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

            case .loginRequest:
                state.loading = true
                return .task { [username = state.login.username, password = state.login.password] in
                    await .loginResponse(TaskResult {
                        try await self.api().request(endpoint: .login(username: username, password: password))
                    })
                }
                .cancellable(id: LoginCancelID.self)

            // swiftlint:disable closure_parameter_position
            case .registerRequest:
                state.loading = true
                return .task { [
                    username = state.createAccount.username,
                    email = state.createAccount.email,
                    password = state.createAccount.password] in
                        await .registerResponse(TaskResult {
                            try await self.api()
                                .request(endpoint: .register(username: username, email: email, password: password))
                        })
                }
                .cancellable(id: RegisterCancelID.self)
            // swiftlint:enable closure_parameter_position

            case .userRequest:
                state.loading = true
                return .task {
                    await .userResponse(TaskResult {
                        try await self.api().request(endpoint: .user)
                    })
                }
                .cancellable(id: UserCancelID.self)

            case .loginResponse(.success((let data, _))):
                database.storeAuthentication(data)
                return .init(value: .userRequest)

            case .loginResponse(.failure):
                state.loading = false
                return .none

            case .registerResponse(.success((let data, _))):
                database.storeAuthentication(data)
                return .init(value: .userRequest)

            case .registerResponse(.failure):
                state.loading = false
                return .none

            case .userResponse(.success((let data, _))):
                state.loading = false
                database.storeUser(data)
                return .init(value: .complete(data))

            case .userResponse(.failure):
                state.loading = false
                return .none

            case .complete:
                return .none

            case .login:
                return .none

            case .createAccount:
                return .none
            }
        }
    }
}
