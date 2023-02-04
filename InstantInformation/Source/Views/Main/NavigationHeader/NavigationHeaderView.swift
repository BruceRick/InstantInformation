//
//  NavigationHeaderView.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-03.
//

import ComposableArchitecture
import SwiftUI

struct NavigationHeaderView: View {
    let store: StoreOf<NavigationHeader>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Content(store: viewStore)
        }
    }
}

private extension NavigationHeaderView {
    struct Content: View {
        let store: ViewStoreOf<NavigationHeader>
    }
}

private extension NavigationHeaderView.Content {
    @ViewBuilder
    var body: some View {
        VStack {
            Text("ii.brick")
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .frame(height: 44)
        .background(.red)
    }
}
