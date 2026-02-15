//
//  MovieDetailsContentView.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import DesignSystem
import SwiftUI

struct MovieDetailsContentView: View {

    var movie: Movie
    var recommendedMovies: [MoviePreview]
    var castMembers: [CastMember]
    var crewMembers: [CrewMember]
    var didSelectPerson: (_ personID: Int) -> Void
    var didSelectMovie: (_ movieID: Int) -> Void
    var navigateToCastAndCrew: (_ movieID: Int) -> Void

    var body: some View {
        StretchyHeaderScrollView(
            header: { header },
            headerOverlay: { headerOverlay },
            content: { content }
        )
        .navigationTitle(movie.title)
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }

}

extension MovieDetailsContentView {

    private var header: some View {
        BackdropImage(url: movie.backdropURL)
            .focalPointAlignment()
            .flexibleHeaderContent(height: 600)
        #if os(macOS)
            .backgroundExtensionEffect()
        #endif
    }

    private var headerOverlay: some View {
        VStack(spacing: 20) {
            LogoImage(url: movie.logoURL)
                .frame(maxWidth: 300, maxHeight: 90, alignment: .bottom)

            VStack {
                HStack {
                    if let genres = movie.genres {
                        Text("\(genres.prefix(4).map(\.name).joined(separator: " ∙ "))")
                            .multilineTextAlignment(.center)
                    }
                }

                HStack(spacing: 4) {
                    if let releaseDate = movie.releaseDate {
                        Text(releaseDate, format: .dateTime.year())
                    }

                    if movie.releaseDate != nil, movie.certification != nil {
                        Text("∙")
                    }

                    if let certification = movie.certification {
                        Text(certification)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .overlay {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(lineWidth: 1)
                            }
                    }
                }
            }
            .font(.callout)
            .padding(.horizontal, 10)
        }
        .padding(.bottom, 10)
    }

    private var content: some View {
        LazyVStack(alignment: .leading, spacing: 10) {
            Section {
                Text(verbatim: movie.overview)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
            }
            .padding(.bottom, 40)

            castAndCrewCarousel
                .padding(.bottom)

            if !recommendedMovies.isEmpty {
                recommendedMoviesCarousel
                    .padding(.bottom)
            }
        }
        .padding(.vertical)
    }

    private var castAndCrewCarousel: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("CAST_AND_CREW") {
                navigateToCastAndCrew(movie.id)
            }

            CastAndCrewCarousel(
                castMembers: castMembers,
                crewMembers: crewMembers,
                didSelectPerson: didSelectPerson
            )
        }
    }

    private var recommendedMoviesCarousel: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("RECOMMENDED")

            RecommendedCarousel(
                movies: recommendedMovies,
                didSelectMovie: didSelectMovie
            )
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

#Preview {
    NavigationStack {
        MovieDetailsContentView(
            movie: Movie.mock,
            recommendedMovies: MoviePreview.mocks,
            castMembers: CastMember.mocks,
            crewMembers: CrewMember.mocks,
            didSelectPerson: { _ in },
            didSelectMovie: { _ in },
            navigateToCastAndCrew: { _ in }
        )
    }
}
