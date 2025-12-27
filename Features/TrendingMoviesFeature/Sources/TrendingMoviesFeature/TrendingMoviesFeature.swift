//
//  TrendingMoviesFeature.swift
//  TrendingMoviesFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import OSLog

@Reducer
public struct TrendingMoviesFeature: Sendable {

    private static let logger = Logger.trendingMovies

    @Dependency(\.trendingMovies) private var trendingMovies

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
        .run { [trendingMovies] send in
            Self.logger.info("User fetching trending movies")

            do {
                let movies = try await trendingMovies.fetch()
                await send(.trendingMoviesLoaded(movies))
            } catch let error {
                Self.logger.error("Failed fetching trending movies: \(error, privacy: .public)")
            }
        }
    }

}
