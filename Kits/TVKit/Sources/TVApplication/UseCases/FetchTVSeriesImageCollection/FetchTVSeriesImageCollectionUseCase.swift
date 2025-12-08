//
//  FetchTVSeriesImageCollectionUseCase.swift
//  TVKit
//
//  Created by Adam Young on 24/11/2025.
//

import Foundation
import TVDomain

public protocol FetchTVSeriesImageCollectionUseCase: Sendable {

    func execute(tvSeriesID: TVSeries.ID) async throws(FetchTVSeriesImageCollectionError)
        -> ImageCollectionDetails

}
