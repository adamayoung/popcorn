//
//  MovieDetailsFeature.swift
//  MovieDetailsFeature
//
//  Created by Adam Young on 17/11/2025.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import OSLog
import Observability

@Reducer
public struct MovieDetailsFeature: Sendable {

    private static let logger = Logger.movieDetails

    @Dependency(\.movieDetailsClient) private var movieDetailsClient
    @Dependency(\.observability) private var observability

    @ObservableState
    public struct State: Sendable {
        let movieID: Int
        public let transitionID: String?
        var viewState: ViewState

        var isWatchlistEnabled: Bool

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

        public init(
            movieID: Int,
            transitionID: String? = nil,
            viewState: ViewState = .initial,
            isWatchlistEnabled: Bool = false
        ) {
            self.movieID = movieID
            self.transitionID = transitionID
            self.viewState = viewState
            self.isWatchlistEnabled = isWatchlistEnabled
        }
    }

    public enum ViewState: Sendable {
        case initial
        case loading
        case ready(ViewSnapshot)
        case error(Error)
    }

    public struct ViewSnapshot: Sendable {
        public let movie: Movie
        public let similarMovies: [MoviePreview]

        public init(
            movie: Movie,
            similarMovies: [MoviePreview]
        ) {
            self.movie = movie
            self.similarMovies = similarMovies
        }
    }

    public enum Action {
        case didAppear
        case updateFeatureFlags
        case stream
        case cancelStream
        case loaded(ViewSnapshot)
        case loadFailed(Error)
        case toggleOnWatchlist
        case toggleOnWatchlistFailed(Error)
        case toggleOnWatchlistCompleted
        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable {
        case movieDetails(id: Int)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didAppear:
                return .run { send in
                    await send(.updateFeatureFlags)
                }

            case .updateFeatureFlags:
                state.isWatchlistEnabled = (try? movieDetailsClient.isWatchlistEnabled()) ?? false
                return .none

            case .stream:
                if case .initial = state.viewState {
                    state.viewState = .loading
                }
                return handleStreamAll(&state)

            case .cancelStream:
                return .cancel(id: CancelID.stream)

            case .loaded(let snapshot):
                state.viewState = .ready(snapshot)
                return .none

            case .loadFailed(let error):
                state.viewState = .error(error)
                return .none

            case .toggleOnWatchlist:
                guard state.isWatchlistEnabled else {
                    return .none
                }

                return handleToggleMovieOnWatchlist(&state)

            case .toggleOnWatchlistFailed:
                return .none

            case .toggleOnWatchlistCompleted:
                return .none

            default:
                return .none
            }
        }
    }

}

extension MovieDetailsFeature {

    private enum CancelID { case stream }

    private func handleStreamAll(_ state: inout State) -> EffectOf<Self> {
        .run { [state, movieDetailsClient] send in
            Self.logger.info("User streaming movie")

            do {
                actor Snapshot {
                    var movie: Movie?
                    var similarMovies: [MoviePreview]?

                    func update(
                        movie: Movie? = nil,
                        similarMovies: [MoviePreview]? = nil,
                        send: Send<MovieDetailsFeature.Action>
                    ) async {
                        if let movie { self.movie = movie }
                        if let similarMovies { self.similarMovies = similarMovies }

                        guard
                            let movie = self.movie,
                            let similarMovies = self.similarMovies
                        else {
                            return
                        }

                        let viewSnapshot = ViewSnapshot(movie: movie, similarMovies: similarMovies)

                        await send(.loaded(viewSnapshot))
                    }
                }

                let snapshot = Snapshot()

                try await withThrowingTaskGroup(of: Void.self) { group in
                    group.addTask {
                        let stream = try await movieDetailsClient.streamMovie(state.movieID)
                        for try await value in stream {
                            await snapshot.update(
                                movie: value,
                                send: send
                            )
                        }
                    }

                    group.addTask {
                        let stream = try await movieDetailsClient.streamSimilar(state.movieID)
                        for try await value in stream {
                            await snapshot.update(
                                similarMovies: value,
                                send: send
                            )
                        }
                    }

                    try await group.waitForAll()
                }
            } catch let error {
                Self.logger.error(
                    "Failed streaming movie: \(error.localizedDescription, privacy: .public)")
                await send(.loadFailed(error))
            }
        }
    }

    private func handleToggleMovieOnWatchlist(_ state: inout State) -> EffectOf<Self> {
        .run { [state] send in
            Self.logger.info(
                "User toggling movie on watchlist [movieID: \(state.movieID, privacy: .private)]")

            let transaction = observability.startTransaction(
                name: "ToggleMovieOnWatchlist",
                operation: .uiAction
            )
            transaction.setData(key: "movie_id", value: state.movieID)

            do {
                try await movieDetailsClient.toggleOnWatchlist(state.movieID)
                transaction.finish()
                await send(.toggleOnWatchlistCompleted)
            } catch let error {
                Self.logger.error(
                    "Failed toggling movie on watchlist [movieID: \(state.movieID, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
                )
                transaction.setData(error: error)
                transaction.finish(status: .internalError)
                await send(.toggleOnWatchlistFailed(error))
            }
        }
    }
}
