//
//  FetchDiscoverTVSeriesUseCase.swift
//  PopcornDiscover
//
//  Created by Adam Young on 08/12/2025.
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
