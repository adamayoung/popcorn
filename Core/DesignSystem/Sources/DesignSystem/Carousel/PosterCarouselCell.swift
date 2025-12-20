//
//  PosterCarouselCell.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

public struct PosterCarouselCell<CellLabel: View>: View {

    private var imageURL: URL?
    private var cellLabel: CellLabel
    private var transitionID: String?
    private var transitionNamespace: Namespace.ID?

    #if os(macOS) || os(visionOS)
        private let width: CGFloat = 150
    #else
        private let width: CGFloat = 150
    #endif

    public init(
        imageURL: URL?,
        transitionID: String? = nil,
        transitionNamespace: Namespace.ID? = nil,
        @ViewBuilder cellLabel: () -> CellLabel
    ) {
        self.imageURL = imageURL
        self.transitionID = transitionID
        self.transitionNamespace = transitionNamespace
        self.cellLabel = cellLabel()
    }

    public var body: some View {
        VStack {
            if let transitionID, let transitionNamespace {
                posterImage
                    .matchedTransitionSource(id: transitionID, in: transitionNamespace)
            } else {
                posterImage
            }

            cellLabel
                .frame(width: width)

            Spacer()
        }
        #if os(visionOS)
        .padding(20)
        .contentShape(.hoverEffect, .rect(cornerRadius: 15))
        .hoverEffect()
        #endif
    }

    private var posterImage: some View {
        PosterImage(url: imageURL)
            .posterWidth(width)
            .cornerRadius(10)
            .clipped()
    }

}

#Preview {
    PosterCarouselCell(
        imageURL: URL(string: "https://image.tmdb.org/t/p/w780/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg")
    ) {
        HStack(alignment: .top, spacing: 15) {
            Text(verbatim: "1")
                .font(.title)
                .bold()
                .foregroundStyle(Color.secondary)

            Text(verbatim: "Fight Club")
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
    }
    .background(Color.secondary)
}
