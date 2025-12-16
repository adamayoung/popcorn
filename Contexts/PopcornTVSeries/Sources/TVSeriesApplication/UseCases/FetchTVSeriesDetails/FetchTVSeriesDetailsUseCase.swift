//
//  FetchTVSeriesDetailsUseCase.swift
//  PopcornTVSeries
//
//  Created by Adam Young on 03/06/2025.
//

import Foundation
import TVSeriesDomain

public protocol FetchTVSeriesDetailsUseCase: Sendable {

    func execute(id: TVSeries.ID) async throws(FetchTVSeriesDetailsError) -> TVSeriesDetails

}
