//
//  PosterCarouselCell.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

/// A carousel cell that displays a poster image with an optional label below.
///
/// Use this component within a carousel to display movies or TV series with their
/// poster images. The cell includes support for matched geometry transitions for
/// smooth navigation animations.
///
/// The cell displays a poster image with rounded corners followed by a customizable
/// label below. On visionOS, the cell includes hover effects for enhanced interaction.
public struct PosterCarouselCell<CellLabel: View>: View {

    /// The URL of the poster image to display.
    private var imageURL: URL?

    /// The custom label view to display below the poster image.
    private var cellLabel: CellLabel

    /// The transition identifier for matched geometry animations, if applicable.
    private var transitionID: String?

    /// The namespace for matched geometry transitions, if applicable.
    private var transitionNamespace: Namespace.ID?

    /// Platform-specific width for the poster image (currently 150 on all platforms).
    #if os(macOS) || os(visionOS)
        private let width: CGFloat = 150
    #else
        private let width: CGFloat = 150
    #endif

    /// Creates a new poster carousel cell.
    ///
    /// - Parameters:
    ///   - imageURL: The URL of the poster image to display.
    ///   - transitionID: The identifier for matched geometry transitions. Defaults to `nil`.
    ///   - transitionNamespace: The namespace for matched geometry transitions. Defaults to `nil`.
    ///   - cellLabel: A view builder that creates the label to display below the image.
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
        // Vertical layout: poster image on top, label below, with spacer for alignment
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
            .clipShape(.rect(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            }
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
}
