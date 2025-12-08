//
//  MovieDetailsView.swift
//  MovieDetailsFeature
//
//  Created by Adam Young on 17/11/2025.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct MovieDetailsView: View {

    @Bindable private var store: StoreOf<MovieDetailsFeature>
    private let namespace: Namespace.ID

    private var movie: Movie? {
        store.movie
    }

    private var isFavourite: Bool {
        store.movie?.isFavourite ?? false
    }

    private var similarMovies: [MoviePreview]? {
        store.similarMovies
    }

    private var isReady: Bool {
        store.isReady
    }

    public init(
        store: StoreOf<MovieDetailsFeature>,
        transitionNamespace: Namespace.ID
    ) {
        self._store = .init(store)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        ZStack {
            if isReady, let movie {
                loadedBody(movie: movie)
            }
        }
        .toolbar {
            if isReady {
                ToolbarItem(placement: .primaryAction) {
                    Button("Favourite", systemImage: isFavourite ? "heart.fill" : "heart") {
                        store.send(.toggleFavourite)
                    }
                    .sensoryFeedback(.selection, trigger: isFavourite)
                }
            }
        }
        .contentTransition(.opacity)
        .animation(.easeInOut(duration: 1), value: isReady)
        .overlay {
            if !isReady {
                loadingBody
            }
        }
        .task { await store.send(.stream).finish() }
    }

}

extension MovieDetailsView {

    private var loadingBody: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func loadedBody(movie: Movie) -> some View {
        StretchyHeaderScrollView(
            header: { header(movie: movie) },
            headerOverlay: { headerOverlay(movie: movie) },
            content: { content(movie: movie) }
        )
        .navigationTitle(movie.title)
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    @ViewBuilder
    private func header(movie: Movie) -> some View {
        BackdropImage(url: movie.backdropURL)
            .flexibleHeaderContent(height: 600)
        //            .backgroundExtensionEffect()
    }

    @ViewBuilder
    private func headerOverlay(movie: Movie) -> some View {
        LogoImage(url: movie.logoURL)
            .padding(.bottom, 20)
            .frame(maxWidth: 300, maxHeight: 150, alignment: .bottom)
    }

    @ViewBuilder
    private func content(movie: Movie) -> some View {
        VStack(alignment: .leading) {
            Text(verbatim: movie.overview)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)

            if let similarMovies, !similarMovies.isEmpty {
                MovieCarousel(movies: similarMovies) { moviePreview in
                    store.send(.navigate(.movieDetails(id: moviePreview.id)))
                }
            }
        }
        .padding(.bottom)
    }

}

#Preview {
    @Previewable @Namespace var namespace

    NavigationStack {
        MovieDetailsView(
            store: Store(
                initialState: MovieDetailsFeature.State(movieID: 1),
                reducer: {
                    MovieDetailsFeature()
                }
            ),
            transitionNamespace: namespace
        )
    }
}
