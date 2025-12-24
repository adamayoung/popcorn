//
//  PopcornIntelligenceAdaptersFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceComposition
import MoviesApplication
import TVSeriesApplication

public final class PopcornIntelligenceAdaptersFactory {

    private let fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase
    private let fetchTVSeriesDetailsUseCase: any FetchTVSeriesDetailsUseCase

    public init(
        fetchMovieDetailsUseCase: some FetchMovieDetailsUseCase,
        fetchTVSeriesDetailsUseCase: some FetchTVSeriesDetailsUseCase
    ) {
        self.fetchMovieDetailsUseCase = fetchMovieDetailsUseCase
        self.fetchTVSeriesDetailsUseCase = fetchTVSeriesDetailsUseCase
    }

    public func makeIntelligenceFactory() -> PopcornIntelligenceFactory {
        let movieProvider = MovieProviderAdapter(
            fetchMovieDetailsUseCase: fetchMovieDetailsUseCase
        )

        let tvSeriesProvider = TVSeriesProviderAdapter(
            fetchTVSeriesDetailsUseCase: fetchTVSeriesDetailsUseCase
        )

        return PopcornIntelligenceFactory(
            movieProvider: movieProvider,
            tvSeriesProvider: tvSeriesProvider
        )
    }

}
