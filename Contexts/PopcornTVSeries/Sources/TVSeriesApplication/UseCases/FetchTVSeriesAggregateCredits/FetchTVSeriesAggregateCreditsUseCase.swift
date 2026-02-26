//
//  FetchTVSeriesAggregateCreditsUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

public protocol FetchTVSeriesAggregateCreditsUseCase: Sendable {

    func execute(
        tvSeriesID: TVSeries.ID
    ) async throws(FetchTVSeriesAggregateCreditsError) -> AggregateCreditsDetails

}
