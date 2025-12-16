//
//  ExploreFeature.swift
//  ExploreFeature
//
//  Created by Adam Young on 21/11/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct ExploreFeature: Sendable {

    @Dependency(\.exploreClient) private var exploreClient: ExploreClient

    @ObservableState
    public struct State {
        public var viewState: ViewState

        public var isLoading: Bool {
            switch viewState {
            case .loading: true
            default: false
            }
        }

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

    public enum ViewState {
        case initial
        case loading
        case ready(ViewSnapshot)
        case error(Error)
    }

    public struct ViewSnapshot {
        public let discoverMovies: [MoviePreview]
        public let trendingMovies: [MoviePreview]
        public let popularMovies: [MoviePreview]
        public let trendingTVSeries: [TVSeriesPreview]
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

    public enum Action {
        case load
        case loaded(ViewSnapshot)
        case loadFailed(Error)
        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable {
        case movieDetails(id: Int, transitionID: String? = nil)
        case tvSeriesDetails(id: Int, transitionID: String? = nil)
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
        .run { [exploreClient] send in
            async let discoverMovies =
                exploreClient.isDiscoverMoviesEnabled() ? exploreClient.fetchDiscoverMovies() : []
            async let trendingMovies =
                exploreClient.isTrendingMoviesEnabled() ? exploreClient.fetchTrendingMovies() : []
            async let popularMovies =
                exploreClient.isPopularMoviesEnabled() ? exploreClient.fetchPopularMovies() : []
            async let trendingTVSeries =
                exploreClient.isTrendingTVSeriesEnabled()
                ? exploreClient.fetchTrendingTVSeries() : []
            async let trendingPeople =
                exploreClient.isTrendingPeopleEnabled() ? exploreClient.fetchTrendingPeople() : []

            do {
                let snapshot = try await ViewSnapshot(
                    discoverMovies: discoverMovies,
                    trendingMovies: trendingMovies,
                    popularMovies: popularMovies,
                    trendingTVSeries: trendingTVSeries,
                    trendingPeople: trendingPeople
                )

                await send(.loaded(snapshot))
            } catch let error {
                await send(.loadFailed(error))
            }
        }
    }

}
