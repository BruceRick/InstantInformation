//
//  MainNavigation.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-03.
//

import ComposableArchitecture

struct MainNavigation: ReducerProtocol {
    struct State: Equatable {
        var navigationHeader = NavigationHeader.State()
        var navigationFooter = NavigationFooter.State()
        var timeline = Timeline.State()
        var more = More.State()

        var showHeader = true
        var showFooter = true
    }

    enum Action {
        case navigationHeader(NavigationHeader.Action)
        case navigationFooter(NavigationFooter.Action)
        case timeline(Timeline.Action)
        case more(More.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .navigationFooter(.selectTab(let tab)):
                state.showHeader = tab == .home
                state.navigationFooter.showNewPost = tab == .home
                return .none

            case .more(.selectMenuItem(.logout)):
                return .init(value: .navigationFooter(.selectTab(.home)))

            case .timeline(.replyingToPost(let id)):
                state.showHeader = id == state.timeline.postReplying
                state.showFooter = id == state.timeline.postReplying
                state.timeline.headerShowing = state.showHeader
                state.timeline.footerShowing = state.showFooter
                return .none

            case .timeline(.postSelected(let id)):
                state.showHeader = id == state.timeline.postSelected
                state.showFooter = id == state.timeline.postSelected
                state.timeline.headerShowing = state.showHeader
                state.timeline.footerShowing = state.showFooter
                return .none

            case .navigationHeader:
                return .none

            case .navigationFooter:
                return .none

            case .timeline:
                return .none

            default:
                return .none
            }
        }

        Scope(state: \.navigationHeader, action: /Action.navigationHeader) {
            NavigationHeader()
        }

        Scope(state: \.navigationFooter, action: /Action.navigationFooter) {
            NavigationFooter()
        }

        Scope(state: \.timeline, action: /Action.timeline) {
            Timeline()
        }

        Scope(state: \.more, action: /Action.more) {
            More()
        }
    }
}
