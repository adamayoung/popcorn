//
//  MovieCarousel.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import DesignSystem
import SwiftUI

struct MovieCarousel: View {

    var movies: [MoviePreview]
    var didSelectMovie: (MoviePreview) -> Void

    var body: some View {
        Carousel {
            ForEach(movies) { movie in
                Button {
                    didSelectMovie(movie)
                } label: {
                    BackdropCarouselCell(
                        imageURL: movie.backdropURL,
                        logoURL: movie.logoURL
                    ) {
                        EmptyView()
                    }
                }
                .buttonStyle(.plain)
                .fixedSize(horizontal: true, vertical: false)
            }
        }
        .contentMargins([.leading, .trailing], 16)
    }

}

#Preview {
    ScrollView {
        MovieCarousel(
            movies: MoviePreview.mocks,
            didSelectMovie: { _ in }
        )
    }
}
