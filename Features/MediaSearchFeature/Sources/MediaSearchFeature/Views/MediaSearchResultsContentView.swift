//
//  MediaSearchResultsContentView.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

struct MediaSearchResultsContentView: View {

    let results: [MediaPreview]
    var onMovieTapped: (MoviePreview) -> Void
    var onTVSeriesTapped: (TVSeriesPreview) -> Void
    var onPersonTapped: (PersonPreview) -> Void

    var body: some View {
        List {
            Section {
                ForEach(results) { media in
                    mediaRow(for: media)
                }
            }
        }
    }

    @ViewBuilder
    private func mediaRow(for media: MediaPreview) -> some View {
        switch media {
        case .movie(let movie):
            MediaSearchMovieRow(movie: movie, onTapped: onMovieTapped)
        case .tvSeries(let tvSeries):
            MediaSearchTVSeriesRow(tvSeries: tvSeries, onTapped: onTVSeriesTapped)
        case .person(let person):
            MediaSearchPersonRow(person: person, onTapped: onPersonTapped)
        }
    }

}

// MARK: - Previews

#Preview("Search Results") {
    NavigationStack {
        MediaSearchResultsContentView(
            results: MediaPreview.mocks,
            onMovieTapped: { _ in },
            onTVSeriesTapped: { _ in },
            onPersonTapped: { _ in }
        )
        .navigationTitle("Search")
    }
}
