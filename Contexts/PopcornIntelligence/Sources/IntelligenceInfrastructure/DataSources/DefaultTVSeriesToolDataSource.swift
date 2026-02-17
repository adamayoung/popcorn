//
//  DefaultTVSeriesToolDataSource.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import FoundationModels
import IntelligenceDomain

///
/// Default implementation of the TV series tool data source
///
/// Provides LLM tools configured with the TV series provider for fetching TV series information.
///
final class DefaultTVSeriesToolDataSource: TVSeriesToolDataSource {

    private let tvSeriesProvider: any TVSeriesProviding

    init(tvSeriesProvider: some TVSeriesProviding) {
        self.tvSeriesProvider = tvSeriesProvider
    }

    func tvSeries() -> any Tool {
        TVSeriesTool(tvSeriesProvider: tvSeriesProvider)
    }

}
