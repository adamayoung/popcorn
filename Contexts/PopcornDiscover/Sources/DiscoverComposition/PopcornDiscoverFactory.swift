//
//  PopcornDiscoverFactory.swift
//  PopcornDiscover
//
//  Created by Adam Young on 08/01/2026.
//

import DiscoverApplication
import Foundation

public protocol PopcornDiscoverFactory: Sendable {

    func makeFetchDiscoverMoviesUseCase() -> FetchDiscoverMoviesUseCase

    func makeFetchDiscoverTVSeriesUseCase() -> FetchDiscoverTVSeriesUseCase

}
