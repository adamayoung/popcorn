//
//  WatchlistFeature.swift
//  WatchlistFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import OSLog
import TCAFoundation

@Reducer
public struct WatchlistFeature: Sendable {

    private static let logger = Logger.watchlist

    @Dependency(\.watchlistClient) private var client

    @ObservableState
    public struct State: Sendable, Equatable {
        var viewState: ViewState<ViewSnapshot>

        public init(
            viewState: ViewState<ViewSnapshot> = .initial
        ) {
            self.viewState = viewState
        }
    }

    public struct ViewSnapshot: Equatable, Sendable {
        public let movies: [MoviePreview]

        public init(movies: [MoviePreview]) {
            self.movies = movies
        }
    }

    public enum Action {
        case fetch
        case moviesLoaded([MoviePreview])
        case moviesUpdated([MoviePreview])
        case loadFailed(ViewStateError)
        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable {
        case movieDetails(id: Int, transitionID: String? = nil)
    }

    public init() {}

    private enum CancelID { case fetch }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetch:
                state.viewState = .loading
                return handleFetch()
                    .cancellable(id: CancelID.fetch, cancelInFlight: true)
            case .moviesLoaded(let movies):
                state.viewState = .ready(ViewSnapshot(movies: movies))
                return .none
            case .moviesUpdated(let movies):
                guard case .ready = state.viewState else {
                    return .none
                }
                state.viewState = .ready(ViewSnapshot(movies: movies))
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

extension WatchlistFeature {

    private func handleFetch() -> EffectOf<Self> {
        .run { [client] send in
            Self.logger.info("User fetching watchlist movies")

            let movies: [MoviePreview]
            do {
                movies = try await client.fetchWatchlistMovies()
            } catch let error {
                Self.logger.error(
                    "Failed fetching watchlist movies: \(error.localizedDescription, privacy: .public)"
                )
                await send(.loadFailed(ViewStateError(error)))
                return
            }

            await send(.moviesLoaded(movies))

            Self.logger.info("Starting watchlist movies stream")

            do {
                let stream = try await client.streamWatchlistMovies()
                for try await updatedMovies in stream {
                    await send(.moviesUpdated(updatedMovies))
                }
            } catch {
                Self.logger.error(
                    "Watchlist movies stream failed: \(error.localizedDescription, privacy: .public)"
                )
            }
        }
    }

}
