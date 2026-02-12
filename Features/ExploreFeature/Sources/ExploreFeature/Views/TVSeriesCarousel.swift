//
//  TVSeriesCarousel.swift
//  ExploreFeature
//
//  Copyright © 2025 Adam Young.
//

import DesignSystem
import SwiftUI

struct TVSeriesCarousel: View {

    enum CarouselType: String {
        case backdrop
        case poster
    }

    var tvSeries: [TVSeriesPreview]
    var type: CarouselType
    var carouselID: String
    var transitionNamespace: Namespace.ID?
    var didSelectTVSeries: (TVSeriesPreview, String) -> Void

    var body: some View {
        Carousel {
            ForEach(Array(tvSeries.enumerated()), id: \.offset) { offset, tvSeries in
                let transitionID = TransitionID(tvSeries: tvSeries, context: carouselID).value

                switch type {
                case .backdrop:
                    Button {
                        didSelectTVSeries(tvSeries, transitionID)
                    } label: {
                        BackdropCarouselCell(
                            imageURL: tvSeries.backdropURL,
                            transitionID: transitionID,
                            transitionNamespace: transitionNamespace
                        ) {
                            cellLabel(title: tvSeries.name, index: offset)
                        }
                    }
                    .buttonStyle(.plain)
                    .fixedSize(horizontal: true, vertical: false)

                case .poster:
                    Button {
                        didSelectTVSeries(tvSeries, transitionID)
                    } label: {
                        PosterCarouselCell(
                            imageURL: tvSeries.posterURL,
                            transitionID: transitionID,
                            transitionNamespace: transitionNamespace
                        ) {
                            cellLabel(title: tvSeries.name, index: offset)
                        }
                    }
                    .buttonStyle(.plain)
                    .fixedSize(horizontal: true, vertical: false)
                }
            }
        }
        .contentMargins([.leading, .trailing], 16)
    }

    private func cellLabel(title: String, index: Int) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Text(verbatim: "\(index + 1)")
                .font(.title)
                .bold()
                .foregroundStyle(Color.secondary)

            Text(verbatim: title)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .fixedSize(horizontal: false, vertical: true)
    }

}

#Preview("Backdrops") {
    @Previewable @Namespace var transitionNamespace

    ScrollView {
        TVSeriesCarousel(
            tvSeries: TVSeriesPreview.mocks,
            type: .backdrop,
            carouselID: "tv-series-backdrops",
            transitionNamespace: transitionNamespace,
            didSelectTVSeries: { _, _ in }
        )
    }
}

#Preview("Posters") {
    @Previewable @Namespace var transitionNamespace

    ScrollView {
        TVSeriesCarousel(
            tvSeries: TVSeriesPreview.mocks,
            type: .poster,
            carouselID: "tv-series-posters",
            transitionNamespace: transitionNamespace,
            didSelectTVSeries: { _, _ in }
        )
    }
}
