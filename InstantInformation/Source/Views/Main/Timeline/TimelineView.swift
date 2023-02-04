//
//  TimelineView.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-03.
//

import ComposableArchitecture
import SwiftUI

struct TimelineView: View {
    let store: StoreOf<Timeline>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Content(store: viewStore)
        }
    }
}

private extension TimelineView {
    struct Content: View {
        let store: ViewStoreOf<Timeline>
    }
}

private extension TimelineView.Content {
    @ViewBuilder
    var body: some View {
        GeometryReader { reader in
            ScrollView {
                VStack(spacing: 10) {
                    content
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                .frame(maxWidth: .infinity)
                .padding(.top, reader.safeAreaInsets.top + 60)
                .padding(.bottom, reader.safeAreaInsets.bottom + 70)
            }
            .ignoresSafeArea()
            .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    var content: some View {
        ForEach(0...25, id: \.self) { _ in
            PostView(profileImage: "profile", name: "Bruce Rick", username: "brick", feed: "all", text:
                """
                Created this app for ii.theScore 's Hackathon!! Made a social media clone to \
                experiment with SwiftUI animations. Also checked out the latest features with \
                SwiftComposableArchitecture. Really enjoyed my experiences and learned \
                a heck of a lot!!!
                """
            )
        }
    }
}
