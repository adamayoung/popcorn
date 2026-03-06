//
//  MovieDetailsContentView.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import DesignSystem
import SwiftUI

struct MovieDetailsContentView: View {

    var movie: Movie
    var recommendedMovies: [MoviePreview]
    var castMembers: [CastMember]
    var crewMembers: [CrewMember]
    var isBackdropFocalPointEnabled: Bool
    var didSelectPerson: (_ personID: Int) -> Void
    var didSelectMovie: (_ movieID: Int) -> Void
    var navigateToCastAndCrew: (_ movieID: Int) -> Void

    private static let toolbarHeaderScrollThreshold: CGFloat = 400

    @State private var showToolbarHeader = false

    var body: some View {
        StretchyHeaderScrollView(
            header: { header },
            headerOverlay: { headerOverlay },
            content: { content },
            onScrollGeometryChange: { geometry in
                let shouldShow = geometry.contentOffset.y > Self.toolbarHeaderScrollThreshold
                if shouldShow != showToolbarHeader {
                    withAnimation {
                        showToolbarHeader = shouldShow
                    }
                }
            }
        )
        .background {
            ZStack {
                if let themeColor = movie.themeColor {
                    Color(red: themeColor.red, green: themeColor.green, blue: themeColor.blue)
                        .opacity(0.5)
                        .ignoresSafeArea()
                }
            }
        }
        .navigationTitle(movie.title)
        #if os(iOS)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ZStack {
                        Color.clear.frame(height: 0)
                        if showToolbarHeader {
                            MediaToolbarHeader(
                                title: movie.title,
                                posterURL: movie.smallPosterURL
                            )
                            .transition(.opacity)
                        }
                    }
                }
            }
        #endif
    }

}

extension MovieDetailsContentView {

    private var header: some View {
        backdropImage
            .flexibleHeaderContent(height: 600)
        #if os(macOS)
            .backgroundExtensionEffect()
        #endif
    }

    @ViewBuilder
    private var backdropImage: some View {
        let image = BackdropImage(url: movie.backdropURL)
        if isBackdropFocalPointEnabled {
            image.focalPointAlignment()
        } else {
            image
        }
    }

    private var headerOverlay: some View {
        VStack(spacing: .spacing20) {
            LogoImage(url: movie.logoURL)
                .frame(maxWidth: 300, maxHeight: 90, alignment: .bottom)

            VStack {
                HStack {
                    if let genres = movie.genres {
                        Text("\(genres.prefix(4).map(\.name).joined(separator: " ∙ "))")
                            .multilineTextAlignment(.center)
                    }
                }

                HStack(spacing: .spacing4) {
                    if let releaseDate = movie.releaseDate {
                        Text(releaseDate, format: .dateTime.year())
                    }

                    if movie.releaseDate != nil, movie.certification != nil {
                        Text("∙")
                    }

                    if let certification = movie.certification {
                        Text(certification)
                            .font(.caption)
                            .padding(.horizontal, .spacing6)
                            .padding(.vertical, .spacing2)
                            .overlay {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(lineWidth: 1)
                            }
                    }
                }
            }
            .font(.callout)
            .padding(.horizontal, .spacing10)
        }
        .padding(.bottom, .spacing10)
    }

    private var content: some View {
        LazyVStack(alignment: .leading, spacing: .spacing10) {
            Section {
                Text(verbatim: movie.overview)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
            }
            .padding(.bottom, .spacing40)

            if !castMembers.isEmpty || !crewMembers.isEmpty {
                castAndCrewCarousel
                    .padding(.bottom)
            }

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
            HStack(spacing: .spacing4) {
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
            isBackdropFocalPointEnabled: true,
            didSelectPerson: { _ in },
            didSelectMovie: { _ in },
            navigateToCastAndCrew: { _ in }
        )
    }
}
