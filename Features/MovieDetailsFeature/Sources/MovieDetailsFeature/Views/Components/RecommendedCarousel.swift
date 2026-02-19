//
//  RecommendedCarousel.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

struct RecommendedCarousel: View {

    var movies: [MoviePreview]
    var didSelectMovie: (_ movieID: Int) -> Void

    var body: some View {
        Carousel {
            ForEach(Array(movies.enumerated()), id: \.offset) { offset, movie in
                Button {
                    didSelectMovie(movie.id)
                } label: {
                    BackdropCarouselCell(
                        imageURL: movie.backdropURL,
                        logoURL: movie.logoURL
                    ) {
                        EmptyView()
                    }
                }
                .accessibilityIdentifier("movie-details.recommended.movie.\(offset)")
                .accessibilityLabel(Text(verbatim: movie.title))
                .accessibilityHint(Text("VIEW_MOVIE_DETAILS_HINT", bundle: .module))
                .buttonStyle(.plain)
                .fixedSize(horizontal: true, vertical: false)
            }
        }
        .accessibilityIdentifier("movie-details.recommended.carousel")
        .contentMargins([.leading, .trailing], 16)
    }

}

#Preview {
    ScrollView {
        RecommendedCarousel(
            movies: MoviePreview.mocks,
            didSelectMovie: { _ in }
        )
    }
}
