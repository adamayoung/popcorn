//
//  Carousel.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

/// A horizontal scrolling carousel container for displaying a collection of views.
///
/// Use this component to create horizontally scrollable collections of items such as
/// movies, TV series, or people. The carousel uses paging behavior to snap items into
/// view when scrolling.
///
/// The carousel wraps content in a horizontal scroll view with lazy loading for
/// performance optimization. Each item in the carousel aligns to the scroll view's
/// edges for a smooth paging experience.
public struct Carousel<Content: View>: View {

    /// The spacing between items in the carousel.
    private var spacing: CGFloat

    /// The content to display in the carousel.
    private var content: Content

    /// Creates a new carousel.
    ///
    /// - Parameters:
    ///   - spacing: The spacing between carousel items. Defaults to `20`.
    ///   - content: A view builder that creates the carousel content.
    public init(spacing: CGFloat = 20, @ViewBuilder _ content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        // Horizontal scroll view with paging behavior
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: spacing) {
                ForEach(subviews: content) { subview in
                    subview
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }

}

#Preview {
    let items: [(name: String, height: CGFloat)] = [
        (name: "Adam", height: 200),
        (name: "Dave", height: 250),
        (name: "Bob", height: 300)
    ]

    Carousel {
        ForEach(items, id: \.name) { item in
            Text(verbatim: item.name)
                .foregroundStyle(.primary)
                .frame(width: 200, height: item.height)
                .background(Color.red)
        }
    }
    .frame(height: 300)
    .padding()
    .background(Color.secondary)
}
