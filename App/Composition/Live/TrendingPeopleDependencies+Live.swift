//
//  TrendingPeopleDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import TrendingApplication
import TrendingComposition
import TrendingPeopleFeature

extension TrendingPeopleDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Uses the trending use case and maps results to ``PersonPreview`` values.
    static func live(services: AppServices) -> TrendingPeopleDependencies {
        let fetchTrendingPeople = services.trendingFactory.makeFetchTrendingPeopleUseCase()

        return TrendingPeopleDependencies(
            fetchTrendingPeople: {
                let personPreviews = try await fetchTrendingPeople.execute()
                let mapper = PersonPreviewMapper()
                return personPreviews.map(mapper.map)
            }
        )
    }

}
