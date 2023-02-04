//
//  MainNavigationView.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-03.
//

import ComposableArchitecture
import SwiftUI

struct MainNavigationView: View {
    let store: StoreOf<MainNavigation>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Content(store: store, viewStore: viewStore)
        }
    }
}

private extension MainNavigationView {
    struct Content: View {
        let store: StoreOf<MainNavigation>
        let viewStore: ViewStoreOf<MainNavigation>
    }
}

private extension MainNavigationView.Content {
    @ViewBuilder
    var body: some View {
        ZStack {
            TimelineView(store: self.store.scope(
                state: \.timeline,
                action: MainNavigation.Action.timeline
            ))

            statusBarBackground
        }
        .overlay(alignment: .top) {
            NavigationHeaderView(store: self.store.scope(
                state: \.navigationHeader,
                action: MainNavigation.Action.navigationHeader
            ))
        }
        .overlay(alignment: .bottom) {
            NavigationFooterView(store: self.store.scope(
                state: \.navigationFooter,
                action: MainNavigation.Action.navigationFooter
            ))
        }
    }

    var statusBarBackground: some View {
        ZStack {
            VStack {
                GeometryReader { geometry in
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 1)
                    Spacer()
                }
            }
        }
    }
}
