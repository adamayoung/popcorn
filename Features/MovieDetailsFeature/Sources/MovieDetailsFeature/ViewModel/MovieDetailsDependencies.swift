//
//  MovieDetailsDependencies.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import MoviesApplication

/// The dependencies required by ``MovieDetailsViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``MovieDetailsViewModel``. Constructing it requires every closure, so a missing
/// dependency is a compile error. Build the production instance with ``live(services:)``.
public struct MovieDetailsDependencies: Sendable {

    public var fetchMovie: @Sendable (_ id: Int) async throws -> Movie
    public var streamMovie: @Sendable (_ id: Int) async throws -> AsyncThrowingStream<Movie?, Error>
    public var fetchRecommendedMovies: @Sendable (_ movieID: Int) async throws -> [MoviePreview]
    public var fetchCredits: @Sendable (_ movieID: Int) async throws -> Credits
    public var toggleOnWatchlist: @Sendable (_ movieID: Int) async throws -> Void

    public var isWatchlistEnabled: @Sendable () throws -> Bool
    public var isIntelligenceEnabled: @Sendable () throws -> Bool
    public var isCastAndCrewEnabled: @Sendable () throws -> Bool
    public var isRecommendedMoviesEnabled: @Sendable () throws -> Bool
    public var isBackdropFocalPointEnabled: @Sendable () throws -> Bool

    public init(
        fetchMovie: @escaping @Sendable (_ id: Int) async throws -> Movie,
        streamMovie: @escaping @Sendable (_ id: Int) async throws -> AsyncThrowingStream<Movie?, Error>,
        fetchRecommendedMovies: @escaping @Sendable (_ movieID: Int) async throws -> [MoviePreview],
        fetchCredits: @escaping @Sendable (_ movieID: Int) async throws -> Credits,
        toggleOnWatchlist: @escaping @Sendable (_ movieID: Int) async throws -> Void,
        isWatchlistEnabled: @escaping @Sendable () throws -> Bool,
        isIntelligenceEnabled: @escaping @Sendable () throws -> Bool,
        isCastAndCrewEnabled: @escaping @Sendable () throws -> Bool,
        isRecommendedMoviesEnabled: @escaping @Sendable () throws -> Bool,
        isBackdropFocalPointEnabled: @escaping @Sendable () throws -> Bool
    ) {
        self.fetchMovie = fetchMovie
        self.streamMovie = streamMovie
        self.fetchRecommendedMovies = fetchRecommendedMovies
        self.fetchCredits = fetchCredits
        self.toggleOnWatchlist = toggleOnWatchlist
        self.isWatchlistEnabled = isWatchlistEnabled
        self.isIntelligenceEnabled = isIntelligenceEnabled
        self.isCastAndCrewEnabled = isCastAndCrewEnabled
        self.isRecommendedMoviesEnabled = isRecommendedMoviesEnabled
        self.isBackdropFocalPointEnabled = isBackdropFocalPointEnabled
    }

}

public extension MovieDetailsDependencies {

    /// Builds the production dependencies from the app's shared services.
    static func live(services: AppServices) -> MovieDetailsDependencies {
        let fetchMovieDetails = services.moviesFactory.makeFetchMovieDetailsUseCase()
        let streamMovieDetails = services.moviesFactory.makeStreamMovieDetailsUseCase()
        let fetchMovieRecommendations = services.moviesFactory.makeFetchMovieRecommendationsUseCase()
        let fetchMovieCredits = services.moviesFactory.makeFetchMovieCreditsUseCase()
        let toggleWatchlistMovie = services.moviesFactory.makeToggleWatchlistMovieUseCase()
        let featureFlags = services.featureFlags

        return MovieDetailsDependencies(
            fetchMovie: { id in
                do {
                    let movie = try await fetchMovieDetails.execute(id: id)
                    return MovieMapper().map(movie)
                } catch {
                    throw FetchMovieError(error)
                }
            },
            streamMovie: { id in
                let movieStream = await streamMovieDetails.stream(id: id)
                return AsyncThrowingStream<Movie?, Error> { continuation in
                    let task = Task {
                        let mapper = MovieMapper()
                        for try await movie in movieStream {
                            guard let movie else {
                                continuation.yield(nil)
                                continue
                            }

                            continuation.yield(mapper.map(movie))
                        }
                        continuation.finish()
                    }
                    continuation.onTermination = { _ in task.cancel() }
                }
            },
            fetchRecommendedMovies: { movieID in
                let movies = try await fetchMovieRecommendations.execute(movieID: movieID)
                let mapper = MoviePreviewMapper()
                return movies.prefix(5).map(mapper.map)
            },
            fetchCredits: { movieID in
                let credits = try await fetchMovieCredits.execute(movieID: movieID)
                return CreditsMapper().map(credits)
            },
            toggleOnWatchlist: { id in
                try await toggleWatchlistMovie.execute(id: id)
            },
            isWatchlistEnabled: { featureFlags.isEnabled(.watchlist) },
            isIntelligenceEnabled: { featureFlags.isEnabled(.movieIntelligence) },
            isCastAndCrewEnabled: { featureFlags.isEnabled(.movieDetailsCastAndCrew) },
            isRecommendedMoviesEnabled: { featureFlags.isEnabled(.movieDetailsRecommendedMovies) },
            isBackdropFocalPointEnabled: { featureFlags.isEnabled(.backdropFocalPoint) }
        )
    }

}

#if DEBUG
    public extension MovieDetailsDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: MovieDetailsDependencies {
            MovieDetailsDependencies(
                fetchMovie: { _ in Movie.mock },
                streamMovie: { _ in
                    AsyncThrowingStream<Movie?, Error> { continuation in
                        continuation.yield(Movie.mock)
                        continuation.finish()
                    }
                },
                fetchRecommendedMovies: { _ in MoviePreview.mocks },
                fetchCredits: { _ in Credits.mock },
                toggleOnWatchlist: { _ in },
                isWatchlistEnabled: { true },
                isIntelligenceEnabled: { true },
                isCastAndCrewEnabled: { true },
                isRecommendedMoviesEnabled: { true },
                isBackdropFocalPointEnabled: { true }
            )
        }

    }
#endif
