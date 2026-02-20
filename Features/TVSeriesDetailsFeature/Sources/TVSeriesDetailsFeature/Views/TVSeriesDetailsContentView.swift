//
//  TVSeriesDetailsContentView.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

struct TVSeriesDetailsContentView: View {

    var tvSeries: TVSeries
    var isBackdropFocalPointEnabled: Bool
    var didSelectSeason: (_ seasonNumber: Int) -> Void

    var body: some View {
        StretchyHeaderScrollView(
            header: { header },
            headerOverlay: { headerOverlay },
            content: { content }
        )
        .navigationTitle(tvSeries.name)
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }

}

extension TVSeriesDetailsContentView {

    private var header: some View {
        backdropImage
            .flexibleHeaderContent(height: 600)
        #if os(macOS)
            .backgroundExtensionEffect()
        #endif
    }

    @ViewBuilder
    private var backdropImage: some View {
        let image = BackdropImage(url: tvSeries.backdropURL)
        if isBackdropFocalPointEnabled {
            image.focalPointAlignment()
        } else {
            image
        }
    }

    private var headerOverlay: some View {
        LogoImage(url: tvSeries.logoURL)
            .padding(.bottom, 20)
            .frame(maxWidth: 300, maxHeight: 150, alignment: .bottom)
    }

    private var content: some View {
        LazyVStack(alignment: .leading, spacing: 10) {
            Text(verbatim: tvSeries.overview)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
                .padding(.bottom, 40)

            if !tvSeries.seasons.isEmpty {
                seasonsCarousel
                    .padding(.bottom)
            }
        }
        .padding(.vertical)
    }

    private var seasonsCarousel: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("SEASONS")

            SeasonsCarousel(
                seasons: tvSeries.seasons,
                didSelectSeason: didSelectSeason
            )
            .accessibilityIdentifier("tv-series-details.seasons.carousel")
        }
    }

    private func sectionHeader(_ key: LocalizedStringKey) -> some View {
        Text(key, bundle: .module)
            .font(.title2)
            .fontWeight(.bold)
            .padding(.horizontal)
    }

}

#Preview("With Seasons") {
    NavigationStack {
        TVSeriesDetailsContentView(
            tvSeries: TVSeries.mock,
            isBackdropFocalPointEnabled: true,
            didSelectSeason: { _ in }
        )
    }
}

#Preview("No Seasons") {
    NavigationStack {
        TVSeriesDetailsContentView(
            tvSeries: TVSeries(
                id: 1,
                name: "Test Series",
                overview: "A series with no seasons data available.",
                seasons: []
            ),
            isBackdropFocalPointEnabled: false,
            didSelectSeason: { _ in }
        )
    }
}
