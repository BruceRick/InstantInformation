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
        @State var opened = false
        @State var selectedTab: Tab = .home
    }
}

private extension NavigationFooterView.Content {
    enum Tab: CaseIterable {
        case home
        case search
        case mentions
        case messages
        case more

        var icon: String {
            switch self {
            case .home:
                return "house"

            case .search:
                return "magnifyingglass"

            case .mentions:
                return "bell"

            case .messages:
                return "envelope"

            case .more:
                return "ellipsis"
            }
        }

        var selectedIcon: String {
            switch self {
            case .home:
                return "house.fill"

            case .search:
                return "magnifyingglass"

            case .mentions:
                return "bell.fill"

            case .messages:
                return "envelope.fill"

            case .more:
                return "ellipsis"
            }
        }
    }

    @ViewBuilder
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack(spacing: 0) {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        if opened || tab == selectedTab {
                            button(tab: tab)
                        }

                        if tab != Tab.allCases.last && opened {
                            verticalSeparator
                        }
                    }
                }
                .background(.thinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(opened ? Color(.systemGray4) : .blue, lineWidth: opened ? 2 : 4)
                )
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.leading, 10)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                .transition(.opacity)
                if !opened {
                    Spacer()
                }
                postButton
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
    }

    var postButton: some View {
        Button { } label: {
            Image(systemName: "plus")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .frame(width: 50, height: 50)
        }
        .foregroundColor(.white)
        .background(.blue)
        .transition(.opacity)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .frame(width: 50, height: 50, alignment: .trailing)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
        .padding(.trailing, 10)
    }

    func button(tab: Tab) -> some View {
        Button {
            withAnimation {
                opened.toggle()
                selectedTab = tab
            }
        } label: {
            Image(systemName: selectedTab == tab ? tab.selectedIcon : tab.icon)
                .font(.system(size: 20))
                .fontWeight(selectedTab == tab ? .bold : .regular)
                .frame(width: 60, height: 60)
        }
        .frame(maxWidth: opened ? .infinity : nil)
        .foregroundColor(selectedTab == tab ? .blue : .gray)
        .transition(.opacity)
        .zIndex(selectedTab == tab ? 0 : -1000)
    }

    var verticalSeparator: some View {
        Rectangle()
            .fill(Color(.systemGray4))
            .frame(width: 1)
            .transition(.move(edge: .leading))
    }
}
