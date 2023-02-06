//
//  MoreView.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-06.
//

import ComposableArchitecture
import SwiftUI

struct MoreView: View {
    let store: StoreOf<More>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Content(store: viewStore)
        }
    }
}

private extension MoreView {
    struct Content: View {
        let store: ViewStoreOf<More>
    }
}

private extension MoreView.Content {
    @ViewBuilder
    var body: some View {
        List {
            Section {
                ForEach(More.MenuItems.allCases, id: \.self) { item in
                    Button {
                        store.send(.selectMenuItem(item), animation: .default)
                    } label: {
                        HStack {
                            Image(systemName: item.icon)
                            Text(item.rawValue.capitalized)
                        }
                    }.foregroundColor(item.colour)
                }
            }

            Section("DEBUG") {
                HStack {
                    Button {
                        store.send(.debugShowWelcomeAnimation)
                    } label: {
                        Text("Show initial animation on welcome screen")
                    }.foregroundColor(.gray)
                    Spacer()
                    Image(systemName: store.showInitialAnimation ? "checkmark" : "xmark")
                        .foregroundColor(store.showInitialAnimation ? .green : .red)
                }
            }
        }
        .onAppear { store.send(.onAppear) }
    }
}
