//
//  MainNavigationView.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-03.
//

import Foundation

import ComposableArchitecture
import SwiftUI

struct MainNavigationView: View {
    let store: StoreOf<MainNavigation>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Content(store: viewStore)
        }
    }
}

private extension MainNavigationView {
    struct Content: View {
        let store: ViewStoreOf<MainNavigation>
    }
}

private extension MainNavigationView.Content {
    @ViewBuilder
    var body: some View {
        Text("Main Navigation")
    }
}
