//
//  Carousel.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

public struct Carousel<Content: View>: View {

    private var spacing: CGFloat
    private var content: Content

    public init(spacing: CGFloat = 20, @ViewBuilder _ content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top, spacing: spacing) {
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
