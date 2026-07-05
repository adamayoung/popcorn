//
//  TrendingMoviesDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import TrendingApplication
import TrendingComposition
import TrendingMoviesFeature

extension TrendingMoviesDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Uses the trending use case and maps results to ``MoviePreview`` values.
    static func live(services: AppServices) -> TrendingMoviesDependencies {
        let fetchTrendingMovies = services.trendingFactory.makeFetchTrendingMoviesUseCase()

        return TrendingMoviesDependencies(
            fetchTrendingMovies: {
                let moviePreviews = try await fetchTrendingMovies.execute()
                let mapper = MoviePreviewMapper()
                return moviePreviews.map(mapper.map)
            }
        )
    }

}
