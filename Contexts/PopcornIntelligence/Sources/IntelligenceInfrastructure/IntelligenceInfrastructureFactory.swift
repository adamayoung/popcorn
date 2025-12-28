//
//  IntelligenceInfrastructureFactory.swift
//  PopcornIntelligence
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain
import Observability

package final class IntelligenceInfrastructureFactory {

    private let movieProvider: any MovieProviding
    private let tvSeriesProvider: any TVSeriesProviding
//    private let observability: any Observing

    package init(
        movieProvider: some MovieProviding,
        tvSeriesProvider: some TVSeriesProviding
//        observability: some Observing
    ) {
        self.movieProvider = movieProvider
        self.tvSeriesProvider = tvSeriesProvider
//        self.observability = observability
    }

    package func makeMovieLLMSessionRepository() -> some MovieLLMSessionRepository {
        let movieToolDataSource = makeMovieToolDataSource()

        return FoundationModelsMovieLLMSessionRepository(
            movieProvider: movieProvider,
            movieToolDataSource: movieToolDataSource
//            observability: observability
        )
    }

    package func makeTVSeriesLLMSessionRepository() -> some TVSeriesLLMSessionRepository {
        let tvSeriesToolDataSource = makeTVSeriesToolDataSource()

        return FoundationModelsTVSeriesLLMSessionRepository(
            tvSeriesProvider: tvSeriesProvider,
            tvSeriesToolDataSource: tvSeriesToolDataSource
//            observability: observability
        )
    }

}

extension IntelligenceInfrastructureFactory {

    private func makeMovieToolDataSource() -> some MovieToolDataSource {
        DefaultMovieToolDataSource(
            movieProvider: movieProvider
        )
    }

    private func makeTVSeriesToolDataSource() -> some TVSeriesToolDataSource {
        DefaultTVSeriesToolDataSource(
            tvSeriesProvider: tvSeriesProvider
        )
    }

}
