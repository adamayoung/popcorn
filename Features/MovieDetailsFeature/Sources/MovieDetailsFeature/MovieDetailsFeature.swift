//
//  MovieDetailsFeature.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import Observability
import OSLog

@Reducer
public struct MovieDetailsFeature: Sendable {

    private static let logger = Logger.movieDetails

    @Dependency(\.movieDetailsClient) private var client
    @Dependency(\.observability) private var observability

    @ObservableState
    public struct State: Sendable {
        let movieID: Int
        public let transitionID: String?
        var viewState: ViewState

        var isWatchlistEnabled: Bool
        var isIntelligenceEnabled: Bool

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
            isWatchlistEnabled: Bool = false,
            isIntelligenceEnabled: Bool = false
        ) {
            self.movieID = movieID
            self.transitionID = transitionID
            self.viewState = viewState
            self.isWatchlistEnabled = isWatchlistEnabled
            self.isIntelligenceEnabled = isIntelligenceEnabled
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
        public let recommendedMovies: [MoviePreview]
        public let castMembers: [CastMember]
        public let crewMembers: [CrewMember]

        public init(
            movie: Movie,
            recommendedMovies: [MoviePreview],
            castMembers: [CastMember],
            crewMembers: [CrewMember]
        ) {
            self.movie = movie
            self.recommendedMovies = recommendedMovies
            self.castMembers = castMembers
            self.crewMembers = crewMembers
        }
    }

    public enum Action {
        case didAppear
        case updateFeatureFlags
        case fetch
        case loaded(ViewSnapshot)
        case loadFailed(Error)
        case toggleOnWatchlist
        case toggleOnWatchlistFailed(Error)
        case toggleOnWatchlistCompleted
        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable {
        case movieDetails(id: Int)
        case movieIntelligence(id: Int)
        case personDetails(id: Int)
        case castAndCrew(movieID: Int)
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
                state.isWatchlistEnabled = (try? client.isWatchlistEnabled()) ?? false
                state.isIntelligenceEnabled = (try? client.isIntelligenceEnabled()) ?? false
                return .none

            case .fetch:
                return handleFetch(&state)

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

    private func handleFetch(_ state: inout State) -> EffectOf<Self> {
        .run { [state, client] send in
            Self.logger.info("User streaming movie")

            async let movie = client.fetchMovie(id: state.movieID)
            async let recommendedMovies = client.fetchRecommendedMovies(movieID: state.movieID)
            async let credits = client.fetchCredits(movieID: state.movieID)

            let viewSnapshot: ViewSnapshot
            do {
                viewSnapshot = try await ViewSnapshot(
                    movie: movie,
                    recommendedMovies: recommendedMovies,
                    castMembers: credits.castMembers,
                    crewMembers: credits.crewMembers
                )
            } catch let error {
                await send(.loadFailed(error))
                return
            }

            await send(.loaded(viewSnapshot))
        }
    }

    private func handleToggleMovieOnWatchlist(_ state: inout State) -> EffectOf<Self> {
        .run { [state, client] send in
            Self.logger.info(
                "User toggling movie on watchlist [movieID: \(state.movieID, privacy: .private)]")

            let transaction = observability.startTransaction(
                name: "ToggleMovieOnWatchlist",
                operation: .uiAction
            )
            transaction.setData(key: "movie_id", value: state.movieID)

            do {
                try await client.toggleOnWatchlist(state.movieID)
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
