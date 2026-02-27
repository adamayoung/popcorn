//
//  FetchTVSeriesCreditsUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

public protocol FetchTVSeriesCreditsUseCase: Sendable {

    func execute(tvSeriesID: TVSeries.ID) async throws(FetchTVSeriesCreditsError) -> CreditsDetails

}
