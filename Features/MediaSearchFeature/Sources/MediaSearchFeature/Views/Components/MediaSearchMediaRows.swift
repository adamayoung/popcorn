//
//  MediaSearchMediaRows.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

struct MediaSearchMovieRow: View {

    let movie: MoviePreview
    var onTapped: (MoviePreview) -> Void

    var body: some View {
        Button {
            onTapped(movie)
        } label: {
            HStack {
                PosterImage(url: movie.posterURL)
                    .posterWidth(60)
                    .clipShape(.rect(cornerRadius: 5))
                    .clipped()

                Text(verbatim: movie.title)
            }
        }
        .buttonStyle(.plain)
    }

}

struct MediaSearchTVSeriesRow: View {

    let tvSeries: TVSeriesPreview
    var onTapped: (TVSeriesPreview) -> Void

    var body: some View {
        Button {
            onTapped(tvSeries)
        } label: {
            HStack {
                PosterImage(url: tvSeries.posterURL)
                    .posterWidth(60)
                    .clipShape(.rect(cornerRadius: 5))
                    .clipped()

                Text(verbatim: tvSeries.name)
            }
        }
        .buttonStyle(.plain)
    }

}

struct MediaSearchPersonRow: View {

    let person: PersonPreview
    var onTapped: (PersonPreview) -> Void

    var body: some View {
        Button {
            onTapped(person)
        } label: {
            HStack {
                ProfileImage(url: person.profileURL, initials: person.initials)
                    .frame(width: 60, height: 60)
                    .clipShape(.circle)

                Text(verbatim: person.name)
            }
        }
        .buttonStyle(.plain)
    }

}
