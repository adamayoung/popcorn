//
//  ProfileCarouselCell.swift
//  DesignSystem
//
//  Created by Adam Young on 09/06/2025.
//

import SwiftUI

public struct ProfileCarouselCell<CellLabel: View>: View {

    private var imageURL: URL?
    private var cellLabel: CellLabel
    private var transitionID: String?
    private var namespace: Namespace.ID?

    #if os(macOS) || os(visionOS)
        private let width: CGFloat = 200
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
        self.namespace = transitionNamespace
        self.cellLabel = cellLabel()
    }

    public var body: some View {
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
            .cornerRadius(width / 2)
            .clipped()
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
