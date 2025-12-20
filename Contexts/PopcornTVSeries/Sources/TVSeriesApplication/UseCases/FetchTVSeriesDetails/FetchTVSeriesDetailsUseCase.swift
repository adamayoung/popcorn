//
//  FetchTVSeriesDetailsUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TVSeriesDomain

public protocol FetchTVSeriesDetailsUseCase: Sendable {

    func execute(id: TVSeries.ID) async throws(FetchTVSeriesDetailsError) -> TVSeriesDetails

}
