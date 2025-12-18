//
//  TrendingMoviesFeature.swift
//  TrendingMoviesFeature
//
//  Created by Adam Young on 17/11/2025.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import OSLog
import Observability

@Reducer
public struct TrendingMoviesFeature: Sendable {

    @Dependency(\.trendingMovies) private var trendingMovies
    @Dependency(\.observability) private var observability

    private static let logger = Logger(
        subsystem: "TrendingMoviesFeature",
        category: "TrendingMoviesFeatureReducer"
    )

    @ObservableState
    public struct State {
        var movies: [MoviePreview]
        var isLoading: Bool
        var isInitiallyLoading: Bool {
            movies.isEmpty && isLoading
        }

        public init(
            movies: [MoviePreview] = [],
            isLoading: Bool = false
        ) {
            self.movies = movies
            self.isLoading = isLoading
        }
    }

    public enum Action {
        case loadTrendingMovies
        case trendingMoviesLoaded([MoviePreview])
        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable {
        case movieDetails(id: Int)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadTrendingMovies:
                state.isLoading = true
                return handleFetchTrendingMovies()
            case .trendingMoviesLoaded(let movies):
                state.movies = movies
                state.isLoading = false
                return .none
            case .navigate:
                return .none
            }
        }
    }

}

extension TrendingMoviesFeature {

    private func handleFetchTrendingMovies() -> EffectOf<Self> {
        .run { send in
            let transaction = observability.startTransaction(
                name: "FetchTrendingMovies",
                operation: .uiAction
            )

            do {
                let movies = try await trendingMovies.fetch()
                transaction.finish()
                await send(.trendingMoviesLoaded(movies))
            } catch let error {
                transaction.setData(error: error)
                transaction.finish(status: .internalError)
                Self.logger.error("Failed fetching trending movies: \(error.localizedDescription)")
            }
        }
    }

}
