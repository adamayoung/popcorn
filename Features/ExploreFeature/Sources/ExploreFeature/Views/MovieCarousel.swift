//
//  MovieCarousel.swift
//  ExploreFeature
//
//  Copyright © 2025 Adam Young.
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
    var transitionNamespace: Namespace.ID?
    var didSelectMovie: (MoviePreview, String) -> Void

    var body: some View {
        Carousel {
            ForEach(Array(movies.enumerated()), id: \.offset) { offset, movie in
                let transitionID = TransitionID(movie: movie, carouselType: type).value

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
                    .buttonStyle(.plain)
                    .fixedSize(horizontal: true, vertical: false)
                }
            }
        }
        .contentMargins([.leading, .trailing], 16)
    }

    @ViewBuilder
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
            transitionNamespace: transitionNamespace,
            didSelectMovie: { _, _ in }
        )
    }
}
