//
//  Timeline.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-03.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct Timeline: ReducerProtocol {
    struct State: Equatable {
        var timeline: [Post] = []
        var replies: [Post] = []

        var postSelected: UUID?
        var postReplying: UUID?

        var headerShowing = true
        var footerShowing = true
    }

    struct Post: Equatable, Hashable {
        let id = UUID()
        let profile: String
        let name: String
        let username: String
        let feed: String
        var image: String?
        var text: String?
        var replyUser: String?
        var isVerified: Bool
    }

    enum Action {
        case onAppear
        case loadTimeline([Post])
        case loadReplies
        case setReplies([Post])
        case replyingToPost(UUID?)
        case postSelected(UUID?)
    }

    @Dependency(\.continuousClock) var clock

    enum CancelID {}
    enum ReplyCancelId {}

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    try await self.clock.sleep(for: .seconds(2))
                    await send(.loadTimeline(Post.mocks), animation: .default)
                }
                .cancellable(id: CancelID.self)

            case .loadTimeline(let timeline):
                if state.timeline.isEmpty {
                    state.timeline = timeline
                }
                return .none

            case .loadReplies:
                return .run { send in
                    try await self.clock.sleep(for: .seconds(2))
                    await send(.setReplies(Post.mockReplies), animation: .default)
                }
                .cancellable(id: ReplyCancelId.self)

            case .setReplies(let replies):
                let postSelected = state.timeline.filter { $0.id == state.postSelected }.first
                var newReplies: [Post] = []

                if let postSelected {
                    for reply in replies {
                        newReplies.append(Post(
                            profile: reply.profile,
                            name: reply.name,
                            username: reply.username,
                            feed: reply.feed,
                            image: reply.image,
                            text: reply.text,
                            replyUser: postSelected.username,
                            isVerified: reply.isVerified
                        ))
                    }
                } else {
                    newReplies = replies
                }

                state.replies = newReplies
                return .none

            case .replyingToPost(let id):
                state.postSelected = nil
                state.postReplying = state.postReplying == id ? nil : id
                state.replies = []
                return .none

            case .postSelected(let id):
                state.postReplying = nil
                state.postSelected = state.postSelected == id ? nil : id
                state.replies = []
                return id == nil ? .none : .init(value: .loadReplies)
            }
        }
    }
}

extension Timeline.Post {
    static var mocks: [Timeline.Post] {
        var mocks: [Timeline.Post] = []

        let hackathonPost = Timeline.Post(profile: "profile", name: "Bruce Rick", username: "brick", feed: "all", text:
            """
            Created this app for ii.theScore 's Hackathon!! Made a social media clone to \
            experiment with SwiftUI animations. Also checked out the latest features with \
            SwiftComposableArchitecture. Really enjoyed the hackathon!
            """,
            isVerified: true
        )
        mocks.append(hackathonPost)

        // swiftlint:disable force_unwrapping
        let user = Timeline.Post.randomUsers.randomElement()!
        // swiftlint:enable force_unwrapping
        let post = Timeline.Post(
            profile: "\(user.image)",
            name: "\(user.name)",
            username: "\(user.username)",
            feed: "\(randomFeed)",
            text:
                """
                For norland produce age wishing. To figure on it spring season up. Her provision acuteness had \
                excellent two why intention. As called mr needed praise at. Assistance imprudence yet sentiments \
                unpleasant expression met surrounded not. Be at talked ye though secure nearer.
                """,
            replyUser: "brick",
            isVerified: user.verified
        )

        mocks.append(post)

        let theScorePost = Timeline.Post(
            profile: "theScore",
            name: "theScore",
            username: "theScore",
            feed: "NBA",
            image: "theScoreImage",
            text: "Mike Brown thinks tonight's loss to the Pels will be a good test for the Kings. 🧐",
            isVerified: true
        )
        mocks.append(theScorePost)

        for _ in 0...25 {
            // swiftlint:disable force_unwrapping
            let user = Timeline.Post.randomUsers.randomElement()!
            // swiftlint:enable force_unwrapping
            let post = Timeline.Post(
                profile: "\(user.image)",
                name: "\(user.name)",
                username: "\(user.username)",
                feed: "\(randomFeed)",
                text: "\(randomText)",
                replyUser: "brick",
                isVerified: user.verified
            )

            mocks.append(post)
        }

        return mocks
    }

    static var mockReplies: [Timeline.Post] {
        var mocks: [Timeline.Post] = []
        for _ in 0...5 {
            // swiftlint:disable force_unwrapping
            let user = Timeline.Post.randomUsers.randomElement()!
            // swiftlint:enable force_unwrapping
            let post = Timeline.Post(
                profile: "\(user.image)",
                name: "\(user.name)",
                username: "\(user.username)",
                feed: "\(randomFeed)",
                text: "\(randomText)",
                replyUser: "brick",
                isVerified: randomUser.verified
            )

            mocks.append(post)
        }

        return mocks
    }
}

extension Timeline.Post {
    struct RandomUser {
        var image: String
        var name: String
        var username: String
        var verified: Bool
    }

    static func uniqueUsers(count: Int) -> [RandomUser] {
        var users: [RandomUser] = []
        for _ in 0...count {
            var user: RandomUser
            var keepRepeating = false
            repeat {
                user = randomUser
                let sameImage = users.filter { $0.image == user.image }.count > 0
                let sameName = users.filter { $0.name == user.name }.count > 0
                let sameUsername = users.filter { $0.username == $0.username }.count > 0
                keepRepeating = sameImage && sameName && sameUsername
            } while keepRepeating

            users.append(user)
        }

        return users
    }

    static var randomUsers = Self.uniqueUsers(count: 15)

    static var randomUser: RandomUser {
        let masculin = Bool.random()
        if masculin {
            return RandomUser(image: randomMHeaderImage,
                              name: randomMName,
                              username: randomUsername,
                              verified: .random())
        } else {
            return RandomUser(image: randomFHeaderImage,
                              name: randomFName,
                              username: randomUsername,
                              verified: .random())
        }
    }

    static var randomMHeaderImage: String {
        String(Int.random(in: 1...10))
    }

    static var randomFHeaderImage: String {
        String(Int.random(in: 11...20))
    }

    static var randomMName: String {
        [
            "Johnathon Alexander MacDonald",
            "Alex Price",
            "Tom D.",
            "John Bergeron",
            "Timothy",
            "Chaz",
            "Charlie MacIntosh",
            "Dan the man",
            "Donald Edward Pearce",
            "David Kovacevic",
            "Alex Tomlinson"
        ].randomElement() ?? ""
    }

    static var randomFName: String {
        [
            "Wendy",
            "Kailey Newersome",
            "Alexandra",
            "Darcy Elizabeth Bergeron",
            "Gina",
            "Lena McBride",
            "Rae",
            "Alice Nyugen",
            "Lisa Alex Rooney",
            "Emily Smitherson",
            "Alana"
        ].randomElement() ?? ""
    }

    static var randomUsername: String {
        [
            "Valkrae",
            "Accept_Crime",
            "TotalGarbodor",
            "InstantAiden",
            "JohnAlexMacD",
            "Failing_Summer",
            "Prime_Time",
            "EinSteiner",
            "DrewLikeTheSoup",
            "Slaterton",
            "Ottawa_Reporter",
            "Ottawatonion",
            "TorontoTransplant",
            "Leafs4Ever",
            "LastOfUs_Fan",
            "Darth_John",
            "JonathonAllState",
            "Flowers_and_Fighters",
            "AddyAdvice",
            "Advice_4_us"
        ].randomElement() ?? ""
    }

    // swiftlint:disable line_length
    static var randomText: String {
        [
            "The extreme cold loosens its grip on Ottawa, allowing people to get out and enjoy winter activities. CTV's Natalie van Rooy reports.",
            "It is so cold in Ottawa!!! My dogs can't even stand being outside for 5 minutes. On top of that the amount of snow we've gotten is insane. Can't wait for the summer",
            "I love Nazem Kadri. One of my favourite Leafs - I'm glad he got his opportunity and won a cup with Colorado but boy oh boy do I wish he was still on the Leafs",
            "I just can't bring myself to play hogwarts legacy. JK Rowling has purposely given into discrimination and I just can't bring my self to support that game.",
            "Vacation to Japan has been booked!! I'm so excited, I saved up for 2 years to have this wonderful trip. Anybody who's gone before have any good suggestions",
            "Hollllllyyyyyy Vancouver just trade Horvat. I can't believe the Islanders were able to sign him for 8 years!!",
            "Toronto trades for Luke Schenn. Talk about coming full circle.",
            "Not a fan of Elon Musk. Always has to be the center of attention and doesn't believe in public services.",
            "It's a shame the city of Ottawa decided to build a train that's privatized. Public transit should always be public and owned by the taxpayers.",
            "Looking to sell 2 tickets to the Leafs tonight $300",
            "Wow what a storm outside.",
            "wholesome monopoly night :) <3 (im currently losing terribly pls like to make me feel better)",
            "Doctors. Nurses. Teachers. ALWAYS defend public services.",
            "Very satisfied with ep 4 of the Last of Us, as per usual 🥺",
            "For norland produce age wishing. To figure on it spring season up. Her provision acuteness had excellent two why intention. As called mr needed praise at. Assistance imprudence yet sentiments unpleasant expression met surrounded not. Be at talked ye though secure nearer.",
            "In by an appetite no humoured returned informed. Possession so comparison inquietude he he conviction no decisively. Marianne jointure attended she hastened surprise but she. Ever lady son yet you very paid form away. He advantage of exquisite resolving if on tolerably. Become sister on in garden it barton waited on.",
            "Person how having tended direct own day man. Saw sufficient indulgence one own you inquietude sympathize.",
            "Whole wound wrote at whose to style in. Figure ye innate former do so we. Shutters but sir yourself provided you required his.",
            "Arrived compass prepare an on as. Reasonable particular on my it in sympathize. Size now easy eat hand how. Unwilling he departure elsewhere dejection at. Heart large seems may purse means few blind. Exquisite newspaper attending on certainty oh suspicion of. He less do quit evil is. Add matter family active mutual put wishes happen.",
            "Style too own civil out along. Perfectly offending attempted add arranging age gentleman concluded. Get who uncommonly our expression ten increasing considered occasional travelling. Ever read tell year give may men call its. Piqued son turned fat income played end wicket. To do noisy downs round an happy books."
        ].randomElement() ?? ""
    }

    static var randomFeed: String {
        [
            "all",
            "hockey",
            "personalThoughts",
            "nhl",
            "videoGames",
            "travelling",
            "cars",
            "clothers",
            "beach",
            "ottawa",
            "toronto",
            "transit",
            "politics",
            "nfl",
            "nhlTrades",
            "hockeyNews",
            "nba",
            "breakingNews",
            "family",
            "friends"
        ].randomElement() ?? ""
    }
    // swiftlint:enable line_length
}
