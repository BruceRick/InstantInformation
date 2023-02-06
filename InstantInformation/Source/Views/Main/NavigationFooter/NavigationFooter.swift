//
//  NavigationFooter.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-03.
//

import Foundation

import ComposableArchitecture

struct NavigationFooter: ReducerProtocol {
    struct State: Equatable {
        var selectedTab: Tab = .home
        var opened = false
        var showNewPost = true
    }

    enum Tab: CaseIterable {
        case home
        case search
        case mentions
        case messages
        case more

        var icon: String {
            switch self {
            case .home:
                return "house"

            case .search:
                return "magnifyingglass"

            case .mentions:
                return "bell"

            case .messages:
                return "envelope"

            case .more:
                return "ellipsis"
            }
        }

        var selectedIcon: String {
            switch self {
            case .home:
                return "house.fill"

            case .search:
                return "magnifyingglass"

            case .mentions:
                return "bell.fill"

            case .messages:
                return "envelope.fill"

            case .more:
                return "ellipsis"
            }
        }
    }

    enum Action {
        case selectTab(Tab)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .selectTab(let tab):
                state.opened.toggle()
                state.selectedTab = tab
                return .none
            }
        }
    }
}
