//
//  ExploreView.swift
//  ExploreFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The explore screen, driven by ``ExploreViewModel``.
///
/// Renders five carousels: discover movies, trending movies, popular movies,
/// trending TV series, and trending people. The view owns its view model via
/// `@State`, so it is self-contained and behaves correctly regardless of how a
/// host retains it. The transition namespace is optional — supply one to enable
/// the zoom transitions into details; omit it (e.g. in isolation or previews)
/// to render without them.
public struct ExploreView: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel: ExploreViewModel
    private let namespace: Namespace.ID?

    public init(
        viewModel: ExploreViewModel,
        transitionNamespace: Namespace.ID? = nil
    ) {
        _viewModel = State(initialValue: viewModel)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        ScrollView {
            ZStack {
                switch viewModel.viewState {
                case .ready(let snapshot):
                    content(
                        discoverMovies: snapshot.discoverMovies,
                        trendingMovies: snapshot.trendingMovies,
                        popularMovies: snapshot.popularMovies,
                        trendingTVSeries: snapshot.trendingTVSeries,
                        trendingPeople: snapshot.trendingPeople
                    )

                case .error(let error):
                    errorBody(error)

                default:
                    EmptyView()
                }
            }
            .contentTransition(.opacity)
            .animation(reduceMotion ? nil : .easeInOut(duration: 1), value: viewModel.viewState.isReady)
        }
        .contentMargins(.bottom, 16, for: .scrollContent)
        .accessibilityIdentifier("explore.view")
        .overlay {
            if viewModel.viewState.isLoading {
                loadingBody
            }
        }
        .navigationTitle(Text("EXPLORE", bundle: .module))
        .task(id: viewModel.reloadID) {
            await viewModel.load()
        }
    }

}

extension ExploreView {

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentLoadErrorView(
            message: error.message,
            systemImage: "popcorn",
            reason: error.reason,
            isRetryable: error.isRetryable,
            retryAction: { viewModel.reload() }
        )
    }

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func content(
        discoverMovies: [MoviePreview],
        trendingMovies: [MoviePreview],
        popularMovies: [MoviePreview],
        trendingTVSeries: [TVSeriesPreview],
        trendingPeople: [PersonPreview]
    ) -> some View {
        LazyVStack {
            if !discoverMovies.isEmpty {
                discoverMoviesSection(discoverMovies)
            }
            if !trendingMovies.isEmpty {
                trendingMoviesSection(trendingMovies)
            }
            if !popularMovies.isEmpty {
                popularMoviesSection(popularMovies)
            }

            if !trendingTVSeries.isEmpty {
                trendingTVSeriesSection(trendingTVSeries)
            }

            if !trendingPeople.isEmpty {
                trendingPeopleSection(trendingPeople)
            }
        }
    }

    @ViewBuilder
    private func discoverMoviesSection(_ movies: [MoviePreview]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                viewModel.selectDiscoverMovies()
            } label: {
                HStack(spacing: .spacing4) {
                    Text("DISCOVER_MOVIES", bundle: .module)
                        .font(.title2)
                        .bold()

                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }
            }
            .accessibilityIdentifier("explore.discover-movies.header")
            .accessibilityAddTraits(.isHeader)
            .accessibilityHint(Text("VIEW_ALL_DISCOVER_MOVIES_HINT", bundle: .module))
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, alignment: .leading)

        MovieCarousel(
            movies: movies,
            type: .backdrop,
            carouselID: "discover-movies",
            transitionNamespace: namespace,
            didSelectMovie: { movie, transitionID in
                viewModel.selectMovie(id: movie.id, transitionID: transitionID)
            }
        )
        .accessibilityIdentifier("explore.discover-movies.carousel")
    }

    @ViewBuilder
    private func trendingMoviesSection(_ movies: [MoviePreview]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                viewModel.selectTrendingMovies()
            } label: {
                HStack(spacing: .spacing4) {
                    Text("TRENDING_MOVIES", bundle: .module)
                        .font(.title2)
                        .bold()

                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }
            }
            .accessibilityIdentifier("explore.trending-movies.header")
            .accessibilityAddTraits(.isHeader)
            .accessibilityHint(Text("VIEW_ALL_TRENDING_MOVIES_HINT", bundle: .module))
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, alignment: .leading)

        MovieCarousel(
            movies: movies,
            type: .poster,
            carouselID: "trending-movies",
            transitionNamespace: namespace,
            didSelectMovie: { movie, transitionID in
                viewModel.selectMovie(id: movie.id, transitionID: transitionID)
            }
        )
        .accessibilityIdentifier("explore.trending-movies.carousel")
    }

    @ViewBuilder
    private func popularMoviesSection(_ movies: [MoviePreview]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                viewModel.selectPopularMovies()
            } label: {
                HStack(spacing: .spacing4) {
                    Text("POPULAR_MOVIES", bundle: .module)
                        .font(.title2)
                        .bold()

                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }
            }
            .accessibilityIdentifier("explore.popular-movies.header")
            .accessibilityAddTraits(.isHeader)
            .accessibilityHint(Text("VIEW_ALL_POPULAR_MOVIES_HINT", bundle: .module))
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, alignment: .leading)

        MovieCarousel(
            movies: movies,
            type: .backdrop,
            carouselID: "popular-movies",
            transitionNamespace: namespace,
            didSelectMovie: { movie, transitionID in
                viewModel.selectMovie(id: movie.id, transitionID: transitionID)
            }
        )
        .accessibilityIdentifier("explore.popular-movies.carousel")
    }

    @ViewBuilder
    private func trendingTVSeriesSection(_ tvSeries: [TVSeriesPreview]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("TRENDING_TV_SERIES", bundle: .module)
                .font(.title2)
                .bold()
                .accessibilityAddTraits(.isHeader)
        }
        .padding(.horizontal)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, alignment: .leading)

        TVSeriesCarousel(
            tvSeries: tvSeries,
            type: .poster,
            carouselID: "trending-tv-series",
            transitionNamespace: namespace,
            didSelectTVSeries: { tvSeries, transitionID in
                viewModel.selectTVSeries(id: tvSeries.id, transitionID: transitionID)
            }
        )
        .accessibilityIdentifier("explore.trending-tv-series.carousel")
    }

    @ViewBuilder
    private func trendingPeopleSection(_ people: [PersonPreview]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("TRENDING_PEOPLE", bundle: .module)
                .font(.title2)
                .bold()
                .accessibilityAddTraits(.isHeader)
        }
        .padding(.horizontal)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, alignment: .leading)

        PersonCarousel(
            people: people,
            carouselID: "trending-people",
            transitionNamespace: namespace,
            didSelectPerson: { person, transitionID in
                viewModel.selectPerson(id: person.id, transitionID: transitionID)
            }
        )
        .accessibilityIdentifier("explore.trending-people.carousel")
    }

}

#if DEBUG
    #Preview("Ready") {
        @Previewable @Namespace var namespace

        NavigationStack {
            ExploreView(
                viewModel: .preview(
                    viewState: .ready(
                        .init(
                            discoverMovies: MoviePreview.mocks,
                            trendingMovies: MoviePreview.mocks,
                            popularMovies: MoviePreview.mocks,
                            trendingTVSeries: TVSeriesPreview.mocks,
                            trendingPeople: PersonPreview.mocks
                        )
                    )
                ),
                transitionNamespace: namespace
            )
        }
    }

    #Preview("Loading") {
        @Previewable @Namespace var namespace

        NavigationStack {
            ExploreView(
                viewModel: .preview(viewState: .loading),
                transitionNamespace: namespace
            )
        }
    }

    #Preview("Error") {
        @Previewable @Namespace var namespace

        NavigationStack {
            ExploreView(
                viewModel: .preview(
                    viewState: .error(ViewStateError(FetchExploreContentError.unknown()))
                ),
                transitionNamespace: namespace
            )
        }
    }
#endif
