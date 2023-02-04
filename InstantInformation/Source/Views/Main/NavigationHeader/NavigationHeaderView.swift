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
        @State var dropdown: Dropdown?
        @State var selectedTimeline: Timeline = .all
        @State var selectedContent: ContentType = .all
    }
}

private extension NavigationHeaderView.Content {
    enum Dropdown {
        case timeline
        case content
    }

    enum Timeline: String, CaseIterable {
        case all
        case hockey
        case politics
        case iosDev
    }

    enum ContentType: CaseIterable {
        case all
        case text
        case images
        case videos
        case media

        var text: String {
            switch self {
            case .all:
                return "All"
            case .text:
                return "Text"
            case .images:
                return "Images"
            case .videos:
                return "Videos"
            case .media:
                return "All Media"
            }
        }

        var icon: String {
            switch self {
            case .all:
                return "doc.richtext"
            case .text:
                return "doc.plaintext"
            case .images:
                return "photo"
            case .videos:
                return "play.rectangle"
            case .media:
                return "doc.text.image"
            }
        }
    }

    @ViewBuilder
    var body: some View {
        VStack {
            VStack {
                HStack(alignment: .top, spacing: 0) {
                    VStack(spacing: 0) {
                        Button {
                            withAnimation {
                                dropdown = dropdown == .timeline ? nil : .timeline
                            }
                        } label: {
                            HStack(alignment: .center, spacing: 6) {
                                Text("ii.brick / \(selectedTimeline.rawValue)")
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                Spacer()
                                Image(systemName: "chevron\(dropdown == .timeline ? ".up" : ".down")")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 44)
                            .padding(.horizontal, 20)
                        }
                        .foregroundColor(.gray)
                        if dropdown == .timeline {
                            ForEach(Timeline.allCases, id: \.rawValue) { timeline in
                                if timeline != self.selectedTimeline {
                                    horizontalSeparator
                                    timelineButton(timeline: timeline)
                                }
                            }
                        }
                    }
                    .background(.thinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color(.systemGray4), lineWidth: 2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal, 10)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    contentButton
                }
                HStack {
                    Spacer()
                        .frame(maxWidth: .infinity)
                    VStack(alignment: .trailing, spacing: 0) {
                        if dropdown == .content {
                            ForEach(ContentType.allCases, id: \.self) { content in
                                if selectedContent != content {
                                    horizontalSeparator
                                    contentMenuButton(content: content)
                                }
                            }
                        }
                    }
                    .frame(width: 130)
                    .background(.thinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.systemGray4), lineWidth: 2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.trailing, 10)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                }
            }
        }
        .padding(.top, 12)
    }

    func timelineButton(timeline: Timeline) -> some View {
        Button {
            withAnimation {
                selectedTimeline = timeline
                dropdown = nil
            }
        } label: {
            Text("/ \(timeline.rawValue)")
                .fontWeight(.medium)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 20)
        }
        .foregroundColor(.gray)
        .transition(.opacity)
        .frame(maxWidth: .infinity)
    }

    var contentButton: some View {
        Button {
            withAnimation {
                dropdown = dropdown == .content ? nil : .content
            }
        } label: {
            HStack(spacing: 0) {
                if dropdown == .content {
                    Text(selectedContent.text)
                        .padding(.leading, 10)
                        .fontWeight(.medium)
                }
                Image(systemName: selectedContent.icon)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .frame(width: 44, height: 44)
            }
        }
        .foregroundColor(.white)
        .background(.blue)
        .transition(.opacity)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
        .padding(.trailing, 10)
        .padding(.top, 2)
    }

    func contentMenuButton(content: ContentType) -> some View {
        Button {
            withAnimation {
                selectedContent = content
                dropdown = nil
            }
        } label: {
            HStack(spacing: 0) {
                Text("\(content.text)")
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .frame(height: 44)
                Image(systemName: content.icon)
                    .font(.system(size: 20))
                    .padding(.horizontal, 10)
            }
        }
        .foregroundColor(selectedContent == content ? .blue : .gray)
        .frame(alignment: .trailing)
        .transition(.opacity)
    }

    var horizontalSeparator: some View {
        Rectangle()
            .fill(Color(.systemGray4))
            .frame(height: 1)
    }
}
