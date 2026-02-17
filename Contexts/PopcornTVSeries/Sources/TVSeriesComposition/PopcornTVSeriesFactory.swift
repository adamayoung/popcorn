//
//  PopcornTVSeriesFactory.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

public protocol PopcornTVSeriesFactory: Sendable {

    func makeFetchTVSeriesDetailsUseCase() -> FetchTVSeriesDetailsUseCase

    func makeFetchTVSeriesImageCollectionUseCase() -> FetchTVSeriesImageCollectionUseCase

}
