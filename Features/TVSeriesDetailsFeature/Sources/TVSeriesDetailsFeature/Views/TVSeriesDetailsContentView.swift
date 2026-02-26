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
    var castMembers: [CastMember]
    var crewMembers: [CrewMember]
    var isBackdropFocalPointEnabled: Bool
    var didSelectSeason: (_ seasonNumber: Int) -> Void
    var didSelectPerson: (_ personID: Int) -> Void
    var navigateToCastAndCrew: (_ tvSeriesID: Int) -> Void

    var body: some View {
        StretchyHeaderScrollView(
            header: { header },
            headerOverlay: { headerOverlay },
            content: { content }
        )
        .navigationTitle(tvSeries.name)
        #if os(iOS)
        .hideToolbarTitle()
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
        VStack(spacing: 20) {
            LogoImage(url: tvSeries.logoURL)
                .frame(maxWidth: 300, maxHeight: 90, alignment: .bottom)

            if let genres = tvSeries.genres, !genres.isEmpty {
                Text(verbatim: genres.prefix(4).map(\.name).joined(separator: " ∙ "))
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
            }
        }
        .padding(.bottom, 10)
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

            if !castMembers.isEmpty || !crewMembers.isEmpty {
                castAndCrewCarousel
                    .padding(.bottom)
            }
        }
        .padding(.vertical)
    }

    private var castAndCrewCarousel: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("CAST_AND_CREW") {
                navigateToCastAndCrew(tvSeries.id)
            }

            CastAndCrewCarousel(
                castMembers: castMembers,
                crewMembers: crewMembers,
                didSelectPerson: didSelectPerson
            )
        }
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

    private func sectionHeader(
        _ key: LocalizedStringKey,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 4) {
                Text(key, bundle: .module)
                    .font(.title2)
                    .fontWeight(.bold)

                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
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
            castMembers: CastMember.mocks,
            crewMembers: CrewMember.mocks,
            isBackdropFocalPointEnabled: true,
            didSelectSeason: { _ in },
            didSelectPerson: { _ in },
            navigateToCastAndCrew: { _ in }
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
            castMembers: [],
            crewMembers: [],
            isBackdropFocalPointEnabled: false,
            didSelectSeason: { _ in },
            didSelectPerson: { _ in },
            navigateToCastAndCrew: { _ in }
        )
    }
}
