//
//  TrendingTVSeriesDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import TrendingApplication
import TrendingComposition
import TrendingTVSeriesFeature

extension TrendingTVSeriesDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Uses the trending use case and maps results to ``TVSeriesPreview`` values.
    static func live(services: AppServices) -> TrendingTVSeriesDependencies {
        let fetchTrendingTVSeries = services.trendingFactory.makeFetchTrendingTVSeriesUseCase()

        return TrendingTVSeriesDependencies(
            fetchTrendingTVSeries: {
                let tvSeriesPreviews = try await fetchTrendingTVSeries.execute()
                let mapper = TVSeriesPreviewMapper()
                return tvSeriesPreviews.map(mapper.map)
            }
        )
    }

}
