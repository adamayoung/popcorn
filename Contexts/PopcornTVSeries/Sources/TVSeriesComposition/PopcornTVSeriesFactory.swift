//
//  PopcornTVSeriesFactory.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

public protocol PopcornTVSeriesFactory: Sendable {

    func makeFetchTVSeriesDetailsUseCase() -> FetchTVSeriesDetailsUseCase

    func makeFetchTVSeriesImageCollectionUseCase() -> FetchTVSeriesImageCollectionUseCase

    func makeFetchTVSeasonDetailsUseCase() -> FetchTVSeasonDetailsUseCase

    func makeFetchTVEpisodeDetailsUseCase() -> FetchTVEpisodeDetailsUseCase

    func makeFetchTVSeriesCreditsUseCase() -> FetchTVSeriesCreditsUseCase

    func makeFetchTVSeriesAggregateCreditsUseCase() -> FetchTVSeriesAggregateCreditsUseCase

}
