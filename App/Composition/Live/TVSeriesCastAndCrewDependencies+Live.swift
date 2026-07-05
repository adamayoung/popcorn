//
//  TVSeriesCastAndCrewDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import TVSeriesApplication
import TVSeriesCastAndCrewFeature
import TVSeriesComposition

extension TVSeriesCastAndCrewDependencies {

    /// Builds the production dependencies from the app's shared services,
    /// wiring the use case, mapper, and error translation.
    static func live(services: AppServices) -> TVSeriesCastAndCrewDependencies {
        let fetchTVSeriesAggregateCredits = services.tvSeriesFactory
            .makeFetchTVSeriesAggregateCreditsUseCase()

        return TVSeriesCastAndCrewDependencies(
            fetchCredits: { tvSeriesID in
                do {
                    let aggregateCredits = try await fetchTVSeriesAggregateCredits
                        .execute(tvSeriesID: tvSeriesID)
                    let mapper = CreditsMapper()
                    return mapper.map(aggregateCredits)
                } catch let error as FetchTVSeriesAggregateCreditsError {
                    throw FetchCreditsError(error)
                }
            }
        )
    }

}
