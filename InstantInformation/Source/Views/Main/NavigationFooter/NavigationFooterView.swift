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
        VStack(alignment: .leading) {
            HStack {
                HStack(spacing: 10) {
                    ForEach(NavigationFooter.Tab.allCases, id: \.self) { tab in
                        if store.opened || tab == store.selectedTab {
                            button(tab: tab)
                        }

                        if tab != NavigationFooter.Tab.allCases.last && store.opened {
                            verticalSeparator
                        }
                    }
                }
                .padding(.horizontal, 10)
                .frame(width: store.opened ? nil : 60, height: 60)
                .background(.thickMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(store.opened ? Color(.systemGray4) : .blue, lineWidth: store.opened ? 2 : 4)
                )
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                .transition(.opacity)
                if !store.opened {
                    Spacer()
                }
                if store.showNewPost {
                    postButton
                }
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity)
    }

    var postButton: some View {
        Button { } label: {
            Image(systemName: "plus")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .frame(width: 60, height: 60)
        }
        .foregroundColor(.white)
        .background(.blue)
        .transition(.opacity)
        .clipShape(Circle())
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
    }

    func button(tab: NavigationFooter.Tab) -> some View {
        Button {
            store.send(.selectTab(tab), animation: .default)
        } label: {
            Image(systemName: store.selectedTab == tab ? tab.selectedIcon : tab.icon)
                .font(.system(size: 20))
                .fontWeight(store.selectedTab == tab ? .bold : .regular)
                .frame(height: 60)
        }
        .frame(maxWidth: store.opened ? .infinity : nil)
        .foregroundColor(store.selectedTab == tab ? .blue : .gray)
        .transition(.opacity)
        .zIndex(store.selectedTab == tab ? 0 : -1000)
    }

    var verticalSeparator: some View {
        Rectangle()
            .fill(Color(.systemGray4))
            .frame(width: 1)
            .transition(.move(edge: .leading))
    }
}
