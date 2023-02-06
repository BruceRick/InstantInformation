//
//  More.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-06.
//

import SwiftUI
import ComposableArchitecture

struct More: ReducerProtocol {
    struct State: Equatable {
        var showInitialAnimation = false
    }

    enum MenuItems: String, CaseIterable {
        case profle
        case topics
        case bookmarks
        case lists
        case timelines
        case logout

        var icon: String {
            switch self {
            case .profle:
                return "person.crop.circle"
            case .topics:
                return "text.bubble"
            case .bookmarks:
                return "bookmark"
            case .lists:
                return "list.bullet.clipboard"
            case .timelines:
                return "house"
            case .logout:
                return "rectangle.portrait.and.arrow.right"
            }
        }

        var colour: Color {
            switch self {
            case .logout:
                return .red
            default:
                return .gray
            }
        }
    }

    enum Action {
        case onAppear
        case debugShowWelcomeAnimation
        case selectMenuItem(MenuItems)
    }

    @Dependency(\.database) var database

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.showInitialAnimation = !database.getDidShowInitialAnimation()
                return .none

            case .debugShowWelcomeAnimation:
                state.showInitialAnimation.toggle()
                database.setDidShowInitialAnimation(!state.showInitialAnimation)
                return .none

            case .selectMenuItem(.logout):
                database.storeUser(nil)
                return .none

            case .selectMenuItem:
                return .none
            }
        }
    }
}
