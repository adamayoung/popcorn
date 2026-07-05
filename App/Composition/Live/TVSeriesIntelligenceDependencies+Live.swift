//
//  TVSeriesIntelligenceDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import IntelligenceApplication
import IntelligenceComposition
import Observability
import TVSeriesApplication
import TVSeriesComposition
import TVSeriesIntelligenceFeature

extension TVSeriesIntelligenceDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Wires the use cases, mapper, and error capture via the shared observability
    /// service.
    static func live(services: AppServices) -> TVSeriesIntelligenceDependencies {
        let fetchTVSeriesDetails = services.tvSeriesFactory.makeFetchTVSeriesDetailsUseCase()
        let createTVSeriesIntelligenceSession = services.intelligenceFactory
            .makeCreateTVSeriesIntelligenceSessionUseCase()
        let observability = services.observability

        return TVSeriesIntelligenceDependencies(
            fetchTVSeries: { id in
                let tvSeries = try await fetchTVSeriesDetails.execute(id: id)
                let mapper = TVSeriesMapper()
                return mapper.map(tvSeries)
            },
            createSession: { tvSeriesID in
                try await createTVSeriesIntelligenceSession.execute(tvSeriesID: tvSeriesID)
            },
            captureError: { error in
                observability.capture(error: error)
            }
        )
    }

}
