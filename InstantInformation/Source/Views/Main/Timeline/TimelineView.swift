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
        Group {
            if store.timeline.isEmpty {
                loadingView
            } else {
                GeometryReader { reader in
                    ScrollView {
                        VStack(spacing: 10) {
                            timeline

                            if store.postReplying != nil || store.postSelected != nil {
                                backMenu
                            }

                            if store.postSelected != nil {
                                if store.replies.isEmpty {
                                    loadingView
                                } else {
                                    replies
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity)
                        .padding(.top, reader.safeAreaInsets.top + (store.headerShowing ? 60 : 0))
                        .padding(.bottom, reader.safeAreaInsets.bottom + (store.footerShowing ? 70 : 0))
                    }
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .onAppear { store.send(.onAppear) }
    }

    var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }.transition(.opacity)
    }

    @ViewBuilder
    var timeline: some View {
        ForEach(store.timeline, id: \.self) { post in
            if store.postReplying == nil &&
                store.postSelected == nil ||
                store.postReplying == post.id ||
                store.postSelected == post.id {
                    PostView(postSelected: { id in store.send(.postSelected(id), animation: .default) },
                             replySelected: { id in store.send(.replyingToPost(id), animation: .default) },
                             id: post.id,
                             profileImage: post.profile,
                             name: post.name,
                             username: post.username,
                             feed: post.feed,
                             image: post.image,
                             text: post.text,
                             isVerified: post.isVerified
                    ).transition(.move(edge: store.timeline.isEmpty ? .top : .leading))
            }
        }
    }

    var backMenu: some View {
        ZStack(alignment: .center) {
            HStack {
                Button {
                    store.send(.replyingToPost(nil), animation: .default)
                    store.send(.postSelected(nil), animation: .default)
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                }
                .foregroundColor(.blue)
                Spacer()
            }
            Text("Replies")
                .foregroundColor(.gray)
        }
        .padding(10)
        .background(.ultraThinMaterial)
        .overlay(
            Capsule()
                .stroke(Color(.systemGray5), lineWidth: 2)
        )
        .clipShape(Capsule())
        .transition(.move(edge: .trailing))
    }

    var replies: some View {
        ForEach(store.replies, id: \.self) { post in
            PostView(postSelected: { id in store.send(.postSelected(id), animation: .default) },
                     replySelected: { id in store.send(.replyingToPost(id), animation: .default) },
                     id: post.id,
                     profileImage: post.profile,
                     name: post.name,
                     username: post.username,
                     feed: post.feed,
                     image: post.image,
                     text: post.text,
                     replyText: post.replyUser,
                     isVerified: post.isVerified
            )
            .transition(.move(edge: store.timeline.isEmpty ? .top : .leading))
            .allowsHitTesting(false)
        }
    }
}
