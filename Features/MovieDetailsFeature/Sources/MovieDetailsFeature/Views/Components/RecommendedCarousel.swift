//
//  RecommendedCarousel.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import DesignSystem
import SwiftUI

struct RecommendedCarousel: View {

    var movies: [MoviePreview]
    var didSelectMovie: (_ movieID: Int) -> Void

    var body: some View {
        Carousel {
            ForEach(movies) { movie in
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
                .buttonStyle(.plain)
                .fixedSize(horizontal: true, vertical: false)
            }
        }
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
