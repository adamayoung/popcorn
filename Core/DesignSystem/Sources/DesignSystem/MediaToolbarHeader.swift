//
//  MediaToolbarHeader.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

public struct MediaToolbarHeader: View {

    private let title: String
    private let posterURL: URL?

    public init(title: String, posterURL: URL? = nil) {
        self.title = title
        self.posterURL = posterURL
    }

    public var body: some View {
        VStack(spacing: 0) {
            PosterImage(url: posterURL)
                .posterHeight(50)
                .zIndex(1)

            Text(verbatim: title)
                .padding(8)
                .glassEffect(.regular, in: .capsule)
                .offset(y: -5)
        }
        .font(.headline)
        .padding(.top, 30)
    }

}
