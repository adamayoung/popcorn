//
//  MovieIntelligenceDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import IntelligenceApplication
import IntelligenceComposition
import MovieIntelligenceFeature
import MoviesApplication
import MoviesComposition
import Observability

extension MovieIntelligenceDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// `captureError` reports through the shared observability service.
    static func live(services: AppServices) -> MovieIntelligenceDependencies {
        let fetchMovieDetails = services.moviesFactory.makeFetchMovieDetailsUseCase()
        let createMovieIntelligenceSession = services.intelligenceFactory
            .makeCreateMovieIntelligenceSessionUseCase()

        return MovieIntelligenceDependencies(
            fetchMovie: { id in
                let movie = try await fetchMovieDetails.execute(id: id)
                return MovieMapper().map(movie)
            },
            createSession: { movieID in
                try await createMovieIntelligenceSession.execute(movieID: movieID)
            },
            captureError: { services.observability.capture(error: $0) }
        )
    }

}
