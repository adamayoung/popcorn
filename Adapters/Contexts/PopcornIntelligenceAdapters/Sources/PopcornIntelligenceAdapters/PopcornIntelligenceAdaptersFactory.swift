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

///
/// A factory for creating intelligence-related adapters.
///
/// Creates adapters that bridge movie and TV series application layers to the
/// intelligence domain.
///
public final class PopcornIntelligenceAdaptersFactory {

    private let fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase
    private let fetchTVSeriesDetailsUseCase: any FetchTVSeriesDetailsUseCase

    ///
    /// Creates an intelligence adapters factory.
    ///
    /// - Parameters:
    ///   - fetchMovieDetailsUseCase: The use case for fetching movie details.
    ///   - fetchTVSeriesDetailsUseCase: The use case for fetching TV series details.
    ///
    public init(
        fetchMovieDetailsUseCase: some FetchMovieDetailsUseCase,
        fetchTVSeriesDetailsUseCase: some FetchTVSeriesDetailsUseCase
    ) {
        self.fetchMovieDetailsUseCase = fetchMovieDetailsUseCase
        self.fetchTVSeriesDetailsUseCase = fetchTVSeriesDetailsUseCase
    }

    ///
    /// Creates an intelligence factory with configured adapters.
    ///
    /// - Returns: A configured ``PopcornIntelligenceFactory`` instance.
    ///
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
