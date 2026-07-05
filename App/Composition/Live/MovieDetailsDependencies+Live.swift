//
//  MovieDetailsDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import FeatureAccess
import MovieDetailsFeature
import MoviesApplication
import MoviesComposition

extension MovieDetailsDependencies {

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
