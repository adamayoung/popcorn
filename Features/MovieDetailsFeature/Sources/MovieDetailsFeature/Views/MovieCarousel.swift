//
//  MovieCarousel.swift
//  ExploreFeature
//
//  Created by Adam Young on 06/06/2025.
//

import DesignSystem
import SwiftUI

struct MovieCarousel: View {

    var movies: [MoviePreview]
    var didSelectMovie: (MoviePreview) -> Void

    var body: some View {
        Carousel {
            ForEach(Array(movies.enumerated()), id: \.offset) { offset, movie in
                Button {
                    didSelectMovie(movie)
                } label: {
                    BackdropCarouselCell(
                        imageURL: movie.backdropURL,
                        logoURL: movie.logoURL
                    ) {
                        cellLabel(title: movie.title, index: offset)
                    }
                }
                .buttonStyle(.plain)
                .fixedSize(horizontal: true, vertical: false)
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

#Preview {
    ScrollView {
        MovieCarousel(
            movies: MoviePreview.mocks,
            didSelectMovie: { _ in }
        )
    }
}
