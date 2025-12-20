//
//  StretchyHeaderScrollView.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

public struct StretchyHeaderScrollView<Header: View, HeaderOverlay: View, Content: View>: View {

    private var header: Header
    private var headerOverlay: HeaderOverlay
    private var content: Content

    public init(
        @ViewBuilder header: () -> Header,
        @ViewBuilder headerOverlay: () -> HeaderOverlay,
        @ViewBuilder content: () -> Content
    ) {
        self.header = header()
        self.headerOverlay = headerOverlay()
        self.content = content()
    }

    public var body: some View {
        ScrollView {
            LazyVStack(alignment: .center) {
                header
                    .overlay(alignment: .bottom) {
                        headerOverlay
                    }

                content
            }
        }
        .flexibleHeaderScrollView()
        .toolbar(removing: .title)
        .ignoresSafeArea(edges: .top)
    }

}

// swiftlint:disable line_length
#Preview {
    NavigationStack {
        StretchyHeaderScrollView(
            header: {
                BackdropImage(
                    url: URL(
                        string: "https://image.tmdb.org/t/p/w1280/56v2KjBlU4XaOv9rVYEQypROD7P.jpg")
                )
                .flexibleHeaderContent(height: 600)
            },
            headerOverlay: {
                Text("Film")
            },
            content: {
                Text(
                    verbatim:
                    "When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces, and one strange little girl."
                )
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            }
        )
    }
}

// swiftlint:enable line_length
