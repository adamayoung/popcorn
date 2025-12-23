//
//  PopcornIntelligenceAdaptersFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceComposition
import MoviesApplication

public final class PopcornIntelligenceAdaptersFactory {

    private let fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase

    public init(fetchMovieDetailsUseCase: some FetchMovieDetailsUseCase) {
        self.fetchMovieDetailsUseCase = fetchMovieDetailsUseCase
    }

    public func makeIntelligenceFactory() -> PopcornIntelligenceFactory {
        let movieProvider = MovieProviderAdapter(
            fetchMovieDetailsUseCase: fetchMovieDetailsUseCase
        )

        return PopcornIntelligenceFactory(
            movieProvider: movieProvider
        )
    }

}
