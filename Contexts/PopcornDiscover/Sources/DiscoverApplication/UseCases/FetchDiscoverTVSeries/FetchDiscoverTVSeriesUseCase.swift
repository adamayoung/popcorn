//
//  FetchDiscoverTVSeriesUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation

public protocol FetchDiscoverTVSeriesUseCase: Sendable {

    func execute() async throws(FetchDiscoverTVSeriesError) -> [TVSeriesPreviewDetails]

    func execute(
        filter: TVSeriesFilter
    ) async throws(FetchDiscoverTVSeriesError) -> [TVSeriesPreviewDetails]

    func execute(page: Int) async throws(FetchDiscoverTVSeriesError) -> [TVSeriesPreviewDetails]

    func execute(
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(FetchDiscoverTVSeriesError) -> [TVSeriesPreviewDetails]

}
