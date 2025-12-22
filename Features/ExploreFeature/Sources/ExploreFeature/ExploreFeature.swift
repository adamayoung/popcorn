//
//  ExploreFeature.swift
//  ExploreFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import Observability
import OSLog

/// A feature that manages the exploration of various media content including movies, TV series, and people.
///
/// This feature aggregates multiple content sources (discover, trending, popular) into a single view,
/// allowing users to explore and navigate to detailed views of different media types.
@Reducer
public struct ExploreFeature: Sendable {

    private static let logger = Logger.explore

    @Dependency(\.exploreClient) private var exploreClient: ExploreClient
    @Dependency(\.observability) private var observability

    /// The state managed by the explore feature.
    ///
    /// Tracks the current view state and provides computed properties for loading and ready states.
    @ObservableState
    public struct State {
        /// The current view state of the explore feature.
        public var viewState: ViewState

        /// Indicates whether content is currently being loaded.
        public var isLoading: Bool {
            switch viewState {
            case .loading: true
            default: false
            }
        }

        /// Indicates whether content has been loaded and is ready to display.
        public var isReady: Bool {
            switch viewState {
            case .ready: true
            default: false
            }
        }

        public init(viewState: ViewState = .initial) {
            self.viewState = viewState
        }
    }

    /// Represents the various states of the explore view.
    public enum ViewState {
        /// Initial state before any data is loaded.
        case initial
        /// Content is currently being fetched.
        case loading
        /// Content has been successfully loaded.
        case ready(ViewSnapshot)
        /// An error occurred while loading content.
        case error(Error)
    }

    /// A snapshot of all explore content loaded from various sources.
    ///
    /// Contains collections of different media types that can be displayed together
    /// in the explore view. Each collection is controlled by feature flags.
    public struct ViewSnapshot: Sendable {
        /// Movies from the discover endpoint.
        public let discoverMovies: [MoviePreview]
        /// Currently trending movies.
        public let trendingMovies: [MoviePreview]
        /// Popular movies.
        public let popularMovies: [MoviePreview]
        /// Currently trending TV series.
        public let trendingTVSeries: [TVSeriesPreview]
        /// Currently trending people.
        public let trendingPeople: [PersonPreview]

        public init(
            discoverMovies: [MoviePreview],
            trendingMovies: [MoviePreview],
            popularMovies: [MoviePreview],
            trendingTVSeries: [TVSeriesPreview],
            trendingPeople: [PersonPreview]
        ) {
            self.discoverMovies = discoverMovies
            self.trendingMovies = trendingMovies
            self.popularMovies = popularMovies
            self.trendingTVSeries = trendingTVSeries
            self.trendingPeople = trendingPeople
        }
    }

    /// Actions that can be performed in the explore feature.
    public enum Action {
        /// Initiates loading of all explore content from enabled sources.
        case load
        /// Content has been successfully loaded.
        case loaded(ViewSnapshot)
        /// Loading content failed with an error.
        case loadFailed(Error)
        /// Navigate to a detail view.
        case navigate(Navigation)
    }

    /// Navigation destinations from the explore feature.
    public enum Navigation: Equatable, Hashable {
        /// Navigate to movie details with optional transition ID for animations.
        case movieDetails(id: Int, transitionID: String? = nil)
        /// Navigate to TV series details with optional transition ID for animations.
        case tvSeriesDetails(id: Int, transitionID: String? = nil)
        /// Navigate to person details with optional transition ID for animations.
        case personDetails(id: Int, transitionID: String? = nil)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .load:
                guard !state.isReady else {
                    return .none
                }

                state.viewState = .loading
                return handleFetchAll()
            case .loaded(let snapshot):
                state.viewState = .ready(snapshot)
                return .none
            case .loadFailed(let error):
                state.viewState = .error(error)
                return .none
            case .navigate:
                return .none
            }
        }
    }

}

extension ExploreFeature {

    private func handleFetchAll() -> EffectOf<Self> {
        .run { [exploreClient, observability] send in
            Self.logger.info("User fetching explore content")

            let isDiscoverMoviesEnabled = (try? exploreClient.isDiscoverMoviesEnabled()) ?? false
            let isTrendingMoviesEnabled = (try? exploreClient.isTrendingMoviesEnabled()) ?? false
            let isPopularMoviesEnabled = (try? exploreClient.isPopularMoviesEnabled()) ?? false
            let isTrendingTVSeriesEnabled =
                (try? exploreClient.isTrendingTVSeriesEnabled()) ?? false
            let isTrendingPeopleEnabled = (try? exploreClient.isTrendingPeopleEnabled()) ?? false

            let transaction = observability.startTransaction(
                name: "FetchExplore",
                operation: .uiAction
            )
            transaction.setData([
                "explore_filters": [
                    "discover_movies": isDiscoverMoviesEnabled,
                    "trending_movies": isTrendingMoviesEnabled,
                    "popular_movies": isPopularMoviesEnabled,
                    "trending_tv_series": isTrendingTVSeriesEnabled,
                    "trending_people": isTrendingPeopleEnabled
                ]
            ])

            do {
                async let discoverMovies =
                    isDiscoverMoviesEnabled ? exploreClient.fetchDiscoverMovies() : []
                async let trendingMovies =
                    isTrendingMoviesEnabled ? exploreClient.fetchTrendingMovies() : []
                async let popularMovies =
                    isPopularMoviesEnabled ? exploreClient.fetchPopularMovies() : []
                async let trendingTVSeries =
                    isTrendingTVSeriesEnabled ? exploreClient.fetchTrendingTVSeries() : []
                async let trendingPeople =
                    isTrendingPeopleEnabled ? exploreClient.fetchTrendingPeople() : []

                let snapshot = try await ViewSnapshot(
                    discoverMovies: discoverMovies,
                    trendingMovies: trendingMovies,
                    popularMovies: popularMovies,
                    trendingTVSeries: trendingTVSeries,
                    trendingPeople: trendingPeople
                )
                transaction.finish()
                await send(.loaded(snapshot))
            } catch {
                transaction.setData(error: error)
                transaction.finish(status: .internalError)
                Self.logger.error(
                    "Failed fetching explore content: \(error.localizedDescription, privacy: .public)"
                )
                await send(.loadFailed(error))
            }
        }
    }

}
