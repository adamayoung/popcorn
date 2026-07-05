//
//  MovieCastAndCrewDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import MovieCastAndCrewFeature
import MoviesApplication
import MoviesComposition

extension MovieCastAndCrewDependencies {

    /// Builds the production dependencies from the app's shared services.
    static func live(services: AppServices) -> MovieCastAndCrewDependencies {
        let fetchMovieCredits = services.moviesFactory.makeFetchMovieCreditsUseCase()

        return MovieCastAndCrewDependencies(
            fetchCredits: { movieID in
                do {
                    let credits = try await fetchMovieCredits.execute(movieID: movieID)
                    let mapper = CreditsMapper()
                    return mapper.map(credits)
                } catch let error as FetchMovieCreditsError {
                    throw FetchCreditsError(error)
                }
            }
        )
    }

}
