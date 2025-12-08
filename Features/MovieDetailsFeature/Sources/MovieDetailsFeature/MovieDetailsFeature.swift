//
//  MovieDetailsFeature.swift
//  MovieDetailsFeature
//
//  Created by Adam Young on 17/11/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct MovieDetailsFeature: Sendable {

    @Dependency(\.movieDetails) var movieDetails: MovieDetailsClient

    @ObservableState
    public struct State {
        var movieID: Int
        public let transitionID: String?
        var movie: Movie?
        var similarMovies: [MoviePreview]?
        var isReady: Bool {
            movie != nil && similarMovies != nil
        }

        public init(
            movieID: Int,
            transitionID: String? = nil,
            movie: Movie? = nil,
            similarMovies: [MoviePreview]? = nil
        ) {
            self.movieID = movieID
            self.transitionID = transitionID
            self.movie = movie
            self.similarMovies = similarMovies
        }
    }

    public enum Action {
        case stream
        case movieLoaded(Movie)
        case similarMoviesLoaded([MoviePreview])
        case toggleFavourite
        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable {
        case movieDetails(id: Int)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .stream:
                return handleStreamAll(&state)

            case .movieLoaded(let movie):
                state.movie = movie
                return .none

            case .similarMoviesLoaded(let moviePreviews):
                state.similarMovies = moviePreviews
                return .none

            case .toggleFavourite:
                return handleToggleFavourite(&state)

            default:
                return .none
            }
        }
    }

}

extension MovieDetailsFeature {

    private func handleStreamAll(_ state: inout State) -> EffectOf<Self> {
        .merge(
            handleStreamMovie(&state),
            handleStreamSimilarMovies(&state)
        )
    }

    private func handleStreamMovie(_ state: inout State) -> EffectOf<Self> {
        let id = state.movieID
        return .run { send in
            for try await movie in await movieDetails.streamMovie(id) {
                if let movie {
                    await send(.movieLoaded(movie))
                }
            }
        }
    }

    private func handleStreamSimilarMovies(_ state: inout State) -> EffectOf<Self> {
        let id = state.movieID
        return .run { send in
            for try await moviePreviews in await movieDetails.streamSimilar(id) {
                await send(.similarMoviesLoaded(moviePreviews))
            }
        }
    }

    private func handleToggleFavourite(_ state: inout State) -> EffectOf<Self> {
        let id = state.movieID
        return .run { send in
            try await movieDetails.toggleFavourite(id)
        }
    }
}
