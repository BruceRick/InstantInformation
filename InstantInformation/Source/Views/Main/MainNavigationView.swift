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
            switch viewStore.navigationFooter.selectedTab {
            case .home:
                TimelineView(store: self.store.scope(
                    state: \.timeline,
                    action: MainNavigation.Action.timeline
                ))
            case .search:
                VStack {
                    Spacer()
                    Text("Search")
                    Spacer()
                }
                .background(.white)
                .frame(maxWidth: .infinity)
                .transition(.move(edge: .leading))
            case .mentions:
                VStack {
                    Spacer()
                    Text("Mentions")
                    Spacer()
                }
                .background(.white)
                .frame(maxWidth: .infinity)
                .transition(.move(edge: .leading))
            case .messages:
                VStack {
                    Spacer()
                    Text("Messages")
                    Spacer()
                }
                .background(.white)
                .padding(.top, 10)
                .frame(maxWidth: .infinity)
                .transition(.move(edge: .leading))
            case .more:
                MoreView(store: self.store.scope(
                    state: \.more,
                    action: MainNavigation.Action.more
                ))
                .transition(.move(edge: .leading))
            }

            statusBarBackground
        }
        .overlay(alignment: .top) {
            if viewStore.showHeader {
                NavigationHeaderView(store: self.store.scope(
                    state: \.navigationHeader,
                    action: MainNavigation.Action.navigationHeader
                ))
            }
        }
        .overlay(alignment: .bottom) {
            if viewStore.showFooter {
                NavigationFooterView(store: self.store.scope(
                    state: \.navigationFooter,
                    action: MainNavigation.Action.navigationFooter
                ))
            }
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
