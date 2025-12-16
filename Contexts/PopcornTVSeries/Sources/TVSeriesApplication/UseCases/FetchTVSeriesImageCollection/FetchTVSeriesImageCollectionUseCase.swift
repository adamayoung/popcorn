//
//  FetchTVSeriesImageCollectionUseCase.swift
//  PopcornTVSeries
//
//  Created by Adam Young on 24/11/2025.
//

import Foundation
import TVSeriesDomain

public protocol FetchTVSeriesImageCollectionUseCase: Sendable {

    func execute(tvSeriesID: TVSeries.ID) async throws(FetchTVSeriesImageCollectionError)
        -> ImageCollectionDetails

}
