//
//  DefaultMovieToolDataSource.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import FoundationModels
import IntelligenceDomain

final class DefaultMovieToolDataSource: MovieToolDataSource {

    private let movieProvider: any MovieProviding

    init(movieProvider: some MovieProviding) {
        self.movieProvider = movieProvider
    }

    func movieDetails() -> any Tool {
        MovieDetailsTool(movieProvider: movieProvider)
    }

}
