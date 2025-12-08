//
//  FetchTrendingTVSeriesUseCase.swift
//  TrendingKit
//
//  Created by Adam Young on 09/06/2025.
//

import Foundation

public protocol FetchTrendingTVSeriesUseCase: Sendable {

    func execute() async throws(FetchTrendingTVSeriesError) -> [TVSeriesPreviewDetails]

    func execute(page: Int) async throws(FetchTrendingTVSeriesError) -> [TVSeriesPreviewDetails]

}
