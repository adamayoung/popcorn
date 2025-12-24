//
//  DefaultMovieToolDataSource.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import FoundationModels
import IntelligenceDomain

///
/// Default implementation of the movie tool data source
///
/// Provides LLM tools configured with the movie provider for fetching movie information.
///
final class DefaultMovieToolDataSource: MovieToolDataSource {

    private let movieProvider: any MovieProviding

    init(movieProvider: some MovieProviding) {
        self.movieProvider = movieProvider
    }

    func movieDetails() -> any Tool {
        MovieDetailsTool(movieProvider: movieProvider)
    }

}
