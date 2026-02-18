//
//  MovieDetailsFeature.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import OSLog
import TCAFoundation

@Reducer
public struct MovieDetailsFeature: Sendable {

    private static let logger = Logger.movieDetails

    @Dependency(\.movieDetailsClient) private var client

    @ObservableState
    public struct State: Sendable, Equatable {
        let movieID: Int
        public let transitionID: String?
        var viewState: ViewState<ViewSnapshot>

        var isWatchlistEnabled: Bool
        var isIntelligenceEnabled: Bool
        var isBackdropFocalPointEnabled: Bool

        public init(
            movieID: Int,
            transitionID: String? = nil,
            viewState: ViewState<ViewSnapshot> = .initial,
            isWatchlistEnabled: Bool = false,
            isIntelligenceEnabled: Bool = false,
            isBackdropFocalPointEnabled: Bool = false
        ) {
            self.movieID = movieID
            self.transitionID = transitionID
            self.viewState = viewState
            self.isWatchlistEnabled = isWatchlistEnabled
            self.isIntelligenceEnabled = isIntelligenceEnabled
            self.isBackdropFocalPointEnabled = isBackdropFocalPointEnabled
        }
    }

    public struct ViewSnapshot: Equatable, Sendable {
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
        case movieUpdated(Movie)
        case loadFailed(ViewStateError)
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
                state.isBackdropFocalPointEnabled = (try? client.isBackdropFocalPointEnabled()) ?? false
                return .none

            case .fetch:
                return handleFetch(&state)

            case .loaded(let snapshot):
                state.viewState = .ready(snapshot)
                return .none

            case .movieUpdated(let movie):
                guard case .ready(let snapshot) = state.viewState else {
                    return .none
                }

                state.viewState = .ready(ViewSnapshot(
                    movie: movie,
                    recommendedMovies: snapshot.recommendedMovies,
                    castMembers: snapshot.castMembers,
                    crewMembers: snapshot.crewMembers
                ))
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
            Self.logger.info("User fetching movie details")

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
            } catch {
                await send(.loadFailed(ViewStateError(error)))
                return
            }

            await send(.loaded(viewSnapshot))

            Self.logger.info("Starting movie details stream")

            do {
                let stream = try await client.streamMovie(state.movieID)
                for try await movie in stream {
                    guard let movie else { continue }
                    await send(.movieUpdated(movie))
                }
            } catch {
                Self.logger.error(
                    "Movie details stream failed: \(error.localizedDescription, privacy: .public)"
                )
            }
        }
    }

    private func handleToggleMovieOnWatchlist(_ state: inout State) -> EffectOf<Self> {
        .run { [state, client] send in
            Self.logger.info(
                "User toggling movie on watchlist [movieID: \(state.movieID, privacy: .private)]"
            )

            do {
                try await client.toggleOnWatchlist(state.movieID)
            } catch let error {
                Self.logger.error(
                    "Failed toggling movie on watchlist [movieID: \(state.movieID, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
                )
                await send(.toggleOnWatchlistFailed(error))
                return
            }

            await send(.toggleOnWatchlistCompleted)
        }
    }
}
