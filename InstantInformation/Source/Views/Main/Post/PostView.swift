//
//  PostView.swift
//  Instant Info
//
//  Created by Bruce Rick on 2023-02-03.
//

import SwiftUI

// swiftlint:disable file_length
// swiftlint:disable type_body_length
struct PostView: View {
    var profileImage: String
    var name: String
    var username: String
    var feed: String
    var text: String

    let isVerfied = true
    @State var liked = false
    @State var reposted = false
    @State var menu: Menu?

    @State var reply = ""

    let padding = 16.0

    enum Menu {
        case replying
        case reporting
        case more

        var menuItems: [MenuItem] {
            switch self {
            case .replying:
                return []

            case .reporting:
                return ReportOptions.allCases.map { MenuItem(icon: $0.icon, text: $0.text ) }

            case .more:
                return  MoreOptions.allCases.map { MenuItem(icon: $0.icon, text: $0.text) }
            }
        }

        var color: Color {
            switch self {
            case .replying:
                return .green

            case .reporting:
                return .red

            case .more:
                return  .blue
            }
        }
    }

    struct MenuItem {
        let icon: String
        let text: String
    }

    enum ReportOptions: CaseIterable {
        case notInterested
        case reportPost
        case mute
        case block
        case report

        var text: String {
            switch self {
            case .notInterested:
                return "Not interested in this Post"
            case .reportPost:
                return "Report this Post"
            case .mute:
                return "Mute ii.brick"
            case .block:
                return "Block ii.brick"
            case .report:
                return "Report ii.brick"
            }
        }

        var icon: String {
            switch self {
            case .notInterested:
                return "text.badge.xmark"
            case .reportPost:
                return "exclamationmark.bubble.fill"
            case .mute:
                return "speaker.slash.fill"
            case .block:
                return "person.fill.badge.minus"
            case .report:
                return "person.crop.circle.badge.exclamationmark.fill"
            }
        }
    }

    enum MoreOptions: CaseIterable {
        case bookmark
        case follow
        case addToTimeline
        case copyLink
        case share

        var text: String {
            switch self {
            case .bookmark:
                return "Bookmark"
            case .follow:
                return "Follow ii.brick"
            case .addToTimeline:
                return "Add to a Timeline"
            case .copyLink:
                return "Copy Link"
            case .share:
                return "Share"
            }
        }

        var icon: String {
            switch self {
            case .bookmark:
                return "bookmark.fill"
            case .follow:
                return "person.fill.badge.plus"
            case .addToTimeline:
                return "checklist"
            case .copyLink:
                return "link"
            case .share:
                return "square.and.arrow.up"
            }
        }
    }

    var borderColor: Color {
        menu?.color ?? Color(.systemGray5)
    }

    var borderWidth: CGFloat {
        menu != nil ? 4.0 : 2.0
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    Image(profileImage)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Capsule())
                    VStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            Text("\(name)")
                                .fontWeight(.bold)
                                .font(.subheadline)
                                .lineLimit(1)
                            Image(systemName: "checkmark.shield.fill")
                                .font(.system(size: 12))
                                .padding(.leading, 4)
                        }
                        HStack(spacing: 0) {
                            Text("ii.\(username)/\(feed)")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                            Text(" • 55m")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, padding/2)
                    Button {
                        withAnimation {
                            menu = menu == .reporting ? nil : .reporting
                        }
                    } label: {
                        Image(systemName: "exclamationmark.circle\(menu == .reporting ? ".fill" : "")")
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                            .frame(alignment: .topTrailing)
                    }
                    .frame(height: 40, alignment: .topTrailing)
                    .padding(.leading, padding)
                    .foregroundColor(menu == .reporting ? menu?.color : Color(.systemGray2))
                }
                .padding(.horizontal, padding)
                .padding(.top, padding)
                .padding(.bottom, padding - 6)
                Text(text)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .padding(.horizontal, padding)
                    .padding(.bottom, padding - 4)
                    .fixedSize(horizontal: false, vertical: true)
                horizontalSeparator
                actionView
                    .fixedSize(horizontal: false, vertical: true)
            }
            .background(.regularMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))

            if menu == .reporting || menu == .more {
                Image(systemName: "arrow.down")
                    .foregroundColor(menu?.color ?? .gray)
                    .transition(.move(edge: .top))
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                    .zIndex(-2)
                actionMenu
            }

            if menu == .replying {
                Image(systemName: "arrow.up")
                    .foregroundColor(.green)
                    .transition(.move(edge: .top))
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .padding(.top, 5)
                    .zIndex(-2)
                Text("Replying to ii.brick")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.green)
                    .padding(.top, 2)
                    .padding(.bottom, 5)
                replyView
            }
        }
        .clipped()
    }

    var actionView: some View {
        HStack(spacing: 0) {
            actionButton(icon: "message\(menu == .replying ? ".fill" : "")",
                         text: "3.5K",
                         selectedColor: menu == .replying ? menu?.color : nil) {
                withAnimation {
                    menu = menu == .replying ? nil : .replying
                }
            }
            verticalSeparator
            actionButton(icon: "arrow.2.squarepath",
                         text: "42K",
                         selectedColor: reposted ? .green : nil) {
                reposted.toggle()
            }
            verticalSeparator
            actionButton(icon: "heart\(liked ? ".fill" : "")",
                         text: "350K",
                         selectedColor: liked ? .pink : nil) {
                liked.toggle()
            }
            verticalSeparator
            actionButton(icon: "ellipsis.circle\(menu == .more ? ".fill" : "")",
                         selectedColor: menu == .more ? menu?.color : nil) {
                withAnimation {
                    menu = menu == .more ? nil : .more
                }
            }
        }
        .frame(height: 44)
    }

    var actionMenu: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(menu?.menuItems ?? [], id: \.text.self) { item in
                HStack(spacing: 10) {
                    Image(systemName: item.icon)
                        .foregroundColor(menu?.color ?? .gray)
                        .fontWeight(.medium)
                    Text(item.text)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .frame(height: 44)
                        .padding(.trailing, 16)
                }
                horizontalSeparator
            }
        }
        .zIndex(-1)
        .frame(maxWidth: .infinity)
        .padding(.leading, 16)
        .background(.regularMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
        .transition(.move(edge: .top))
    }

    var replyView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 0) {
                Image(profileImage)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Capsule())
                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        Text("\(name)")
                            .fontWeight(.bold)
                            .font(.subheadline)
                            .lineLimit(1)
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 10))
                            .padding(.leading, 4)
                    }
                    Text("ii.\(username)/\(feed)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, padding/2)
            }
            VStack(spacing: 0) {
                TextField("Post your reply", text: $reply, axis: .vertical)
                    .font(.subheadline)
                    .fontWeight(.light)
                Spacer()
            }
            .padding(10)
            .frame(minHeight: 100)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.systemGray5), lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            Button {
                withAnimation {
                    reply = ""
                    menu = nil
                }
            } label: {
                Text("Post Reply")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 35)
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Capsule())
            .padding(.top, 10)
            .transition(.opacity)
        }
        .zIndex(-1)
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(.regularMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
        .transition(.move(edge: .top))
    }

    var horizontalSeparator: some View {
        Rectangle()
            .fill(Color(.systemGray5))
            .frame(height: 1)
    }

    var verticalSeparator: some View {
        Rectangle()
            .fill(Color(.systemGray5))
            .frame(width: 1)
    }

    func actionButton(icon: String,
                      text: String? = nil,
                      selectedColor: Color? = nil,
                      action: (() -> Void)? = nil) -> some View {
        Button {
            action?()
        } label: {
            HStack(spacing: 0) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                if let text {
                    Text(text)
                        .font(.footnote)
                        .fontWeight(.medium)
                        .padding(.leading, 5)
                }
            }.frame(maxWidth: .infinity)
        }
        .foregroundColor(selectedColor ?? Color(.systemGray2))
    }
}

// MARK: - SwiftUI previews

struct PostView_Previews: PreviewProvider {
  static var previews: some View {
      VStack(spacing: 10) {
          PostView(profileImage: "profile",
                   name: "Bruce Rick",
                   username: "brick",
                   feed: "all",
                   text:
                """
                Created this app for ii.theScore 's Hackathon!! Made a social media clone to \
                experiment with SwiftUI animations. Also checked out the latest features with \
                SwiftComposableArchitecture. Really enjoyed my experiences and learned \
                a heck of a lot!!!
                """
          ).padding(.horizontal, 10)
          PostView(profileImage: "profile",
                   name: "Bruce Rick",
                   username: "brick",
                   feed: "BreakingNews",
                   text:
                """
                Created this app for ii.theScore 's Hackathon!! Made a social media clone to \
                experiment with SwiftUI animations. Also checked out the latest features with \
                SwiftComposableArchitecture. Really enjoyed my experiences and learned
                a heck of a lot!!!
                """,
                   liked: true,
                   reposted: true
          ).padding(.horizontal, 10)
          PostView(profileImage: "profile",
                   name: "Jonathon Alexander McDonald",
                   username: "jonathonmcdonald",
                   feed: "breakingNews",
                   text:
                """
                Created this app for ii.theScore 's Hackathon!! Made a social media clone to \
                experiment with SwiftUI animations. Also checked out the latest features with \
                SwiftComposableArchitecture. Really enjoyed my experiences and learned
                a heck of a lot!!!
                """
          ).padding(.horizontal, 16)
      }
  }
}

// swiftlint:enable type_body_length
// swiftlint:enable file_length
