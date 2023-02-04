//
//  MainNavigation.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-03.
//

import ComposableArchitecture

struct MainNavigation: ReducerProtocol {
    struct State: Equatable {
        let navigationHeader = NavigationHeader.State()
        let navigationFooter = NavigationFooter.State()
        let timeline = Timeline.State()
    }

    enum Action {
        case onAppear

        case navigationHeader(NavigationHeader.Action)
        case navigationFooter(NavigationFooter.Action)
        case timeline(Timeline.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { _, action in
            switch action {
            case .onAppear:
                return .none

            case .navigationHeader:
                return .none

            case .navigationFooter:
                return .none

            case .timeline:
                return .none
            }
        }
    }
}
