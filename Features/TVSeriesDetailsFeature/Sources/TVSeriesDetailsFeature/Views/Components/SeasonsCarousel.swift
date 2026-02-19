//
//  SeasonsCarousel.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

struct SeasonsCarousel: View {

    var seasons: [TVSeasonPreview]
    var didSelectSeason: (_ seasonNumber: Int) -> Void

    var body: some View {
        Carousel {
            ForEach(Array(seasons.enumerated()), id: \.offset) { offset, season in
                Button {
                    didSelectSeason(season.seasonNumber)
                } label: {
                    PosterCarouselCell(imageURL: season.posterURL) {
                        Text(verbatim: season.name)
                            .lineLimit(2, reservesSpace: true)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .accessibilityIdentifier("tv-series-details.seasons.season.\(offset)")
                .accessibilityLabel(season.name)
                .accessibilityHint(Text("VIEW_SEASON_DETAILS_HINT", bundle: .module))
                .buttonStyle(.plain)
                .fixedSize(horizontal: true, vertical: false)
            }
        }
        .accessibilityIdentifier("tv-series-details.seasons.carousel")
        .contentMargins([.leading, .trailing], 16)
    }

}

#Preview {
    ScrollView {
        SeasonsCarousel(
            seasons: TVSeries.mock.seasons,
            didSelectSeason: { _ in }
        )
    }
}
