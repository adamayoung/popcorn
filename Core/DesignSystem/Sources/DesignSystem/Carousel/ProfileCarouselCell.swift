//
//  ProfileCarouselCell.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

/// A carousel cell that displays a circular profile image with an optional label below.
///
/// Use this component within a carousel to display people such as cast members, crew,
/// or other person entities. The cell includes support for matched geometry transitions
/// for smooth navigation animations.
///
/// The cell displays a circular profile image followed by a customizable label below.
/// The circular shape is achieved by setting the corner radius to half the image width.
public struct ProfileCarouselCell<CellLabel: View>: View {

    /// The URL of the profile image to display.
    private var imageURL: URL?

    /// The custom label view to display below the profile image.
    private var cellLabel: CellLabel

    /// The transition identifier for matched geometry animations, if applicable.
    private var transitionID: String?

    /// The namespace for matched geometry transitions, if applicable.
    private var namespace: Namespace.ID?

    // Platform-specific width for the profile image.
    #if os(macOS) || os(visionOS)
        private let width: CGFloat = 200
    #else
        private let width: CGFloat = 150
    #endif

    /// Creates a new profile carousel cell.
    ///
    /// - Parameters:
    ///   - imageURL: The URL of the profile image to display.
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
        self.namespace = transitionNamespace
        self.cellLabel = cellLabel()
    }

    public var body: some View {
        // Vertical layout: circular profile image on top, label below
        VStack {
            if let transitionID, let namespace {
                profileImage
                    .matchedTransitionSource(id: transitionID.description, in: namespace)
            } else {
                profileImage
            }

            cellLabel
                .frame(width: width)
                .frame(maxHeight: .infinity)
        }
    }

    private var profileImage: some View {
        ProfileImage(url: imageURL)
            .frame(width: width, height: width)
            .clipShape(.rect(cornerRadius: width / 2))
            .overlay {
                RoundedRectangle(cornerRadius: width / 2)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            }
    }

}

#Preview {
    ProfileCarouselCell(
        imageURL: URL(string: "https://image.tmdb.org/t/p/h632/q4TanMDI5Rgsvw4SfyNbPBh4URr.jpg")
    ) {
        HStack(alignment: .top, spacing: 15) {
            Text(verbatim: "1")
                .font(.title)
                .bold()
                .foregroundStyle(Color.secondary)

            Text(verbatim: "Stanley Tucci")
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
    }
}
