//
//  PopcornDiscoverFactory.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import DiscoverApplication
import Foundation

public protocol PopcornDiscoverFactory: Sendable {

    func makeFetchDiscoverMoviesUseCase() -> FetchDiscoverMoviesUseCase

    func makeFetchDiscoverTVSeriesUseCase() -> FetchDiscoverTVSeriesUseCase

}
