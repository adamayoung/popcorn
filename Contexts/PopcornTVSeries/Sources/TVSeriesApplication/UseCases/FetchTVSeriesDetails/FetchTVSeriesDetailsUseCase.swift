//
//  FetchTVSeriesDetailsUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

public protocol FetchTVSeriesDetailsUseCase: Sendable {

    func execute(id: TVSeries.ID) async throws(FetchTVSeriesDetailsError) -> TVSeriesDetails

}
