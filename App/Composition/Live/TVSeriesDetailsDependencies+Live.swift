//
//  TVSeriesDetailsDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import FeatureAccess
import Observability
import TVSeriesApplication
import TVSeriesComposition
import TVSeriesDetailsFeature

extension TVSeriesDetailsDependencies {

    /// Builds the production dependencies from the app's shared services,
    /// including use cases, mappers, feature flags, and observability spans.
    static func live(services: AppServices) -> TVSeriesDetailsDependencies {
        let fetchTVSeriesDetails = services.tvSeriesFactory.makeFetchTVSeriesDetailsUseCase()
        let fetchTVSeriesCredits = services.tvSeriesFactory.makeFetchTVSeriesCreditsUseCase()
        let featureFlags = services.featureFlags

        return TVSeriesDetailsDependencies(
            fetchTVSeries: { id in
                let span = SpanContext.startChild(
                    operation: .clientFetch,
                    description: "TVSeriesDetailsClient.fetch"
                )
                span?.setData(key: "tv_series_id", value: id)

                do {
                    let tvSeries = try await fetchTVSeriesDetails.execute(id: id)
                    let mapper = TVSeriesMapper()
                    let result = mapper.map(tvSeries)
                    span?.finish()
                    return result
                } catch let error {
                    span?.setData(error: error)
                    span?.finish(status: .internalError)
                    throw FetchTVSeriesError(error)
                }
            },
            fetchCredits: { tvSeriesID in
                let span = SpanContext.startChild(
                    operation: .clientFetch,
                    description: "TVSeriesDetailsClient.fetchCredits"
                )
                span?.setData(key: "tv_series_id", value: tvSeriesID)

                do {
                    let creditsDetails = try await fetchTVSeriesCredits.execute(tvSeriesID: tvSeriesID)
                    let mapper = CreditsMapper()
                    let result = mapper.map(creditsDetails)
                    span?.finish()
                    return result
                } catch let error {
                    span?.setData(error: error)
                    span?.finish(status: .internalError)
                    throw error
                }
            },
            isCastAndCrewEnabled: { featureFlags.isEnabled(.tvSeriesDetailsCastAndCrew) },
            isIntelligenceEnabled: { featureFlags.isEnabled(.tvSeriesIntelligence) },
            isBackdropFocalPointEnabled: { featureFlags.isEnabled(.backdropFocalPoint) }
        )
    }

}
