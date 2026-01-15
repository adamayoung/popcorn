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
            .flexibleHeaderContent(height: 600)
        #if os(macOS)
            .backgroundExtensionEffect()
        #endif
    }

    private var headerOverlay: some View {
        VStack {
            LogoImage(url: movie.logoURL)
                .frame(maxWidth: 300, maxHeight: 90, alignment: .bottom)

            Text("2023")
                .foregroundStyle(.white)
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
                didSelectPerson: { personID in
                    didSelectPerson(personID)
                }
            )
        }
    }

    private var recommendedMoviesCarousel: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("RECOMMENDED")

            RecommendedCarousel(
                movies: recommendedMovies,
                didSelectMovie: { movieID in
                    didSelectMovie(movieID)
                }
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
