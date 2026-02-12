//
//  BackdropCarouselCell.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

/// A carousel cell that displays a backdrop image with an optional label below.
///
/// Use this component within a carousel to display movies or TV series with their
/// backdrop images. The cell includes support for matched geometry transitions for
/// smooth navigation animations.
///
/// The cell displays a backdrop image with rounded corners and an optional logo overlay,
/// followed by a customizable label below. On visionOS, the cell includes hover effects
/// for enhanced interaction.
public struct BackdropCarouselCell<CellLabel: View>: View {

    /// The URL of the backdrop image to display.
    private var imageURL: URL?

    /// The URL of the logo image to overlay on the backdrop, if available.
    private var logoURL: URL?

    /// The custom label view to display below the backdrop image.
    private var cellLabel: CellLabel

    /// The transition identifier for matched geometry animations, if applicable.
    private var transitionID: String?

    /// The namespace for matched geometry transitions, if applicable.
    private var namespace: Namespace.ID?

    // Platform-specific width for the backdrop image.
    #if os(macOS) || os(visionOS)
        private let width: CGFloat = 300
    #else
        private let width: CGFloat = 250
    #endif

    /// Corner radius for the backdrop image.
    private let cornerRadius: CGFloat = 20

    /// Creates a new backdrop carousel cell.
    ///
    /// - Parameters:
    ///   - imageURL: The URL of the backdrop image to display.
    ///   - logoURL: The URL of the logo image to overlay. Defaults to `nil`.
    ///   - transitionID: The identifier for matched geometry transitions. Defaults to `nil`.
    ///   - transitionNamespace: The namespace for matched geometry transitions. Defaults to `nil`.
    ///   - cellLabel: A view builder that creates the label to display below the image.
    public init(
        imageURL: URL?,
        logoURL: URL? = nil,
        transitionID: String? = nil,
        transitionNamespace: Namespace.ID? = nil,
        @ViewBuilder cellLabel: () -> CellLabel
    ) {
        self.imageURL = imageURL
        self.logoURL = logoURL
        self.transitionID = transitionID
        self.namespace = transitionNamespace
        self.cellLabel = cellLabel()
    }

    public var body: some View {
        // Vertical layout: backdrop image on top, label below
        VStack {
            if let transitionID, let namespace {
                backdropImage
                    .matchedTransitionSource(id: transitionID.description, in: namespace)
            } else {
                backdropImage
            }

            cellLabel
                .frame(width: width)
                .frame(maxHeight: .infinity)
        }
        #if os(visionOS)
        .padding(20)
        .contentShape(.hoverEffect, .rect(cornerRadius: 30))
        .hoverEffect()
        #endif
    }

    private var backdropImage: some View {
        BackdropImage(url: imageURL, logoURL: logoURL)
            .backdropWidth(width)
            .clipShape(.rect(cornerRadius: cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            }
    }

}

#Preview {
    ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(alignment: .top, spacing: 20) {
            BackdropCarouselCell(
                imageURL: URL(
                    string: "https://image.tmdb.org/t/p/w1280/xRyINp9KfMLVjRiO5nCsoRDdvvF.jpg"
                )
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
            .fixedSize(horizontal: true, vertical: false)
        }
        .scrollTargetLayout()
        .frame(height: 200)
    }
    .scrollTargetBehavior(.viewAligned)
}
