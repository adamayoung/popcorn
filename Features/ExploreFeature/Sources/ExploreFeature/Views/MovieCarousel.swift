//
//  MovieCarousel.swift
//  ExploreFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

struct MovieCarousel: View {

    enum CarouselType: String {
        case backdrop
        case poster
    }

    var movies: [MoviePreview]
    var type: CarouselType
    var carouselID: String
    var transitionNamespace: Namespace.ID?
    var didSelectMovie: (MoviePreview, String) -> Void

    var body: some View {
        Carousel {
            ForEach(Array(movies.enumerated()), id: \.offset) { offset, movie in
                let transitionID = TransitionID(movie: movie, context: carouselID).value

                switch type {
                case .backdrop:
                    Button {
                        didSelectMovie(movie, transitionID)
                    } label: {
                        BackdropCarouselCell(
                            imageURL: movie.backdropURL,
                            logoURL: movie.logoURL,
                            transitionID: transitionID,
                            transitionNamespace: transitionNamespace
                        ) {
                            cellLabel(title: movie.title, index: offset)
                        }
                    }
                    .accessibilityIdentifier("explore.\(carouselID).movie.\(offset)")
                    .accessibilityLabel(movie.title)
                    .buttonStyle(.plain)
                    .fixedSize(horizontal: true, vertical: false)

                case .poster:
                    Button {
                        didSelectMovie(movie, transitionID)
                    } label: {
                        PosterCarouselCell(
                            imageURL: movie.posterURL,
                            transitionID: transitionID,
                            transitionNamespace: transitionNamespace
                        ) {
                            cellLabel(title: movie.title, index: offset)
                        }
                    }
                    .accessibilityIdentifier("explore.\(carouselID).movie.\(offset)")
                    .accessibilityLabel(movie.title)
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
        MovieCarousel(
            movies: MoviePreview.mocks,
            type: .backdrop,
            carouselID: "movie-backdrops",
            transitionNamespace: transitionNamespace,
            didSelectMovie: { _, _ in }
        )
    }
}

#Preview("Posters") {
    @Previewable @Namespace var transitionNamespace

    ScrollView {
        MovieCarousel(
            movies: MoviePreview.mocks,
            type: .poster,
            carouselID: "movie-posters",
            transitionNamespace: transitionNamespace,
            didSelectMovie: { _, _ in }
        )
    }
}
