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
        WelcomeView(store: self.store.scope(
            state: \.welcome,
            action: Root.Action.welcome
        ))
    }
}
