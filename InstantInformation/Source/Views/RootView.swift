//
//  RootView.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-01.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: StoreOf<Root>

    var body: some View {
        content
            .onAppear { ViewStore(self.store).send(.onAppear) }
    }

    var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Group {
                if viewStore.user != nil {
                    MainNavigationView(store: self.store.scope(
                        state: \.mainNavigation,
                        action: Root.Action.mainNavigation
                    )).transition(.move(edge: .leading))
                } else {
                    WelcomeView(store: self.store.scope(
                        state: \.welcome,
                        action: Root.Action.welcome
                    )).transition(.move(edge: .top))
                }
            }.onAppear { viewStore.send(.onAppear) }
        }
    }
}
