//
//  PopcornIntelligenceAdaptersFactory.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2026 Adam Young.
//

import IntelligenceDomain
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

    public func makeMovieProvider() -> some MovieProviding {
        MovieProviderAdapter(fetchMovieDetailsUseCase: fetchMovieDetailsUseCase)
    }

    public func makeTVSeriesProvider() -> some TVSeriesProviding {
        TVSeriesProviderAdapter(fetchTVSeriesDetailsUseCase: fetchTVSeriesDetailsUseCase)
    }

    public func makeCreditsProvider() -> some CreditsProviding {
        CreditsProviderAdapter(fetchMovieCreditsUseCase: fetchMovieCreditsUseCase)
    }

}
