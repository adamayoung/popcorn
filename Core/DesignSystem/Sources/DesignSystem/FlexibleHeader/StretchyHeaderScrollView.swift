//
//  StretchyHeaderScrollView.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

///
/// A scroll view with a stretchy header that expands when pulled down.
///
/// Use this component to create detail views with a prominent header image
/// that stretches when the user pulls down, similar to the behavior seen
/// in many media applications.
///
public struct StretchyHeaderScrollView<Header: View, HeaderOverlay: View, Content: View>: View {

    private var header: Header
    private var headerOverlay: HeaderOverlay
    private var content: Content

    /// Creates a new stretchy header scroll view.
    ///
    /// - Parameters:
    ///   - header: A view builder that creates the header content.
    ///   - headerOverlay: A view builder that creates content to overlay on the header.
    ///   - content: A view builder that creates the scrollable content below the header.
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
