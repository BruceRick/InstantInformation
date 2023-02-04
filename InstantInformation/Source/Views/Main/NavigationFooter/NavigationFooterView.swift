//
//  NavigationFooterView.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-03.
//

import ComposableArchitecture
import SwiftUI

struct NavigationFooterView: View {
    let store: StoreOf<NavigationFooter>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Content(store: viewStore)
        }
    }
}

private extension NavigationFooterView {
    struct Content: View {
        let store: ViewStoreOf<NavigationFooter>
    }
}

private extension NavigationFooterView.Content {
    @ViewBuilder
    var body: some View {
        VStack {
            Text("Footer")
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
        .frame(height: 44)
        .background(.red)
    }
}
