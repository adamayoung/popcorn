//
//  FetchTVSeriesImageCollectionUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TVSeriesDomain

public protocol FetchTVSeriesImageCollectionUseCase: Sendable {

    func execute(tvSeriesID: TVSeries.ID) async throws(FetchTVSeriesImageCollectionError)
        -> ImageCollectionDetails

}
