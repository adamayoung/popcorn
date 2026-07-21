//
//  PopularMoviesDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import MoviesApplication
import MoviesComposition
import PopularMoviesFeature

extension PopularMoviesDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Uses the popular movies use case and maps results to ``MoviePreview`` values.
    static func live(services: AppServices) -> PopularMoviesDependencies {
        let fetchPopularMovies = services.moviesFactory.makeFetchPopularMoviesUseCase()

        return PopularMoviesDependencies(
            fetchPopularMovies: { page in
                let detailsPage = try await fetchPopularMovies.execute(page: page)
                let mapper = MoviePreviewMapper()
                return mapper.map(detailsPage)
            }
        )
    }

}
