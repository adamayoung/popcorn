//
//  PopcornIntelligenceAdaptersFactory.swift
//  PopcornIntelligenceAdapters
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
    private let fetchMovieCreditsUseCase: any FetchMovieCreditsUseCase

    public init(
        fetchMovieDetailsUseCase: some FetchMovieDetailsUseCase,
        fetchTVSeriesDetailsUseCase: some FetchTVSeriesDetailsUseCase,
        fetchMovieCreditsUseCase: some FetchMovieCreditsUseCase
    ) {
        self.fetchMovieDetailsUseCase = fetchMovieDetailsUseCase
        self.fetchTVSeriesDetailsUseCase = fetchTVSeriesDetailsUseCase
        self.fetchMovieCreditsUseCase = fetchMovieCreditsUseCase
    }

    public func makeIntelligenceFactory() -> some PopcornIntelligenceFactory {
        let movieProvider = MovieProviderAdapter(
            fetchMovieDetailsUseCase: fetchMovieDetailsUseCase
        )

        let tvSeriesProvider = TVSeriesProviderAdapter(
            fetchTVSeriesDetailsUseCase: fetchTVSeriesDetailsUseCase
        )

        let creditsProvider = CreditsProviderAdapter(
            fetchMovieCreditsUseCase: fetchMovieCreditsUseCase
        )

        return LivePopcornIntelligenceFactory(
            movieProvider: movieProvider,
            tvSeriesProvider: tvSeriesProvider,
            creditsProvider: creditsProvider
        )
    }

}
