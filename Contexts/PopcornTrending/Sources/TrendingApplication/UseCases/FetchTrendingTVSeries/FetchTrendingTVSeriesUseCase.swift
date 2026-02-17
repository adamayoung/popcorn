//
//  FetchTrendingTVSeriesUseCase.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol FetchTrendingTVSeriesUseCase: Sendable {

    func execute() async throws(FetchTrendingTVSeriesError) -> [TVSeriesPreviewDetails]

    func execute(page: Int) async throws(FetchTrendingTVSeriesError) -> [TVSeriesPreviewDetails]

}
