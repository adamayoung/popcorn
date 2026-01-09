//
//  UITestPopcornTVSeriesFactory.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TVSeriesApplication
import TVSeriesComposition
import TVSeriesDomain

public final class UITestPopcornTVSeriesFactory: PopcornTVSeriesFactory {

    private let applicationFactory: TVSeriesApplicationFactory

    public init() {
        self.applicationFactory = TVSeriesApplicationFactory(
            tvSeriesRepository: StubTVSeriesRepository(),
            appConfigurationProvider: StubAppConfigurationProvider()
        )
    }

    public func makeFetchTVSeriesDetailsUseCase() -> FetchTVSeriesDetailsUseCase {
        applicationFactory.makeFetchTVSeriesDetailsUseCase()
    }

    public func makeFetchTVSeriesImageCollectionUseCase() -> FetchTVSeriesImageCollectionUseCase {
        applicationFactory.makeFetchTVSeriesImageCollectionUseCase()
    }

}
