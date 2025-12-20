//
//  BackdropCarouselCell.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

public struct BackdropCarouselCell<CellLabel: View>: View {

    private var imageURL: URL?
    private var logoURL: URL?
    private var cellLabel: CellLabel
    private var transitionID: String?
    private var namespace: Namespace.ID?

    #if os(macOS) || os(visionOS)
        private let width: CGFloat = 300
    #else
        private let width: CGFloat = 250
    #endif

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
            .cornerRadius(20)
            .clipped()
    }

}

#Preview {
    ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(alignment: .top, spacing: 20) {
            BackdropCarouselCell(
                imageURL: URL(
                    string: "https://image.tmdb.org/t/p/w1280/xRyINp9KfMLVjRiO5nCsoRDdvvF.jpg")
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
    }
    .scrollTargetBehavior(.viewAligned)
}
