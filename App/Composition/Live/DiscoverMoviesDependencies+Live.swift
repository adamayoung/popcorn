//
//  DiscoverMoviesDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import DiscoverApplication
import DiscoverComposition
import DiscoverMoviesFeature

extension DiscoverMoviesDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Uses the discover use case (no filter, default sort) and maps each page of
    /// results to ``MoviePreview`` values.
    static func live(services: AppServices) -> DiscoverMoviesDependencies {
        let fetchDiscoverMovies = services.discoverFactory.makeFetchDiscoverMoviesUseCase()

        return DiscoverMoviesDependencies(
            fetchDiscoverMovies: { page in
                let detailsPage = try await fetchDiscoverMovies.execute(page: page)
                let mapper = MoviePreviewMapper()
                return mapper.map(detailsPage)
            }
        )
    }

}
