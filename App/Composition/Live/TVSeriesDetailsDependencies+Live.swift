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
        let streamTVSeriesDetails = services.tvSeriesFactory.makeStreamTVSeriesDetailsUseCase()
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
            streamTVSeries: makeStreamTVSeries(using: streamTVSeriesDetails),
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

    /// Wraps the context stream use case, remapping each emitted context ``TVSeriesDetails``
    /// to the feature's presentation ``TVSeries`` and finishing the stream on error.
    private static func makeStreamTVSeries(
        using streamTVSeriesDetails: any StreamTVSeriesDetailsUseCase
    ) -> @Sendable (_ id: Int) async -> AsyncThrowingStream<TVSeries?, Error> {
        { id in
            let tvSeriesStream = await streamTVSeriesDetails.stream(id: id)
            return AsyncThrowingStream<TVSeries?, Error> { continuation in
                let task = Task {
                    do {
                        let mapper = TVSeriesMapper()
                        for try await tvSeries in tvSeriesStream {
                            guard let tvSeries else {
                                continuation.yield(nil)
                                continue
                            }

                            continuation.yield(mapper.map(tvSeries))
                        }
                        continuation.finish()
                    } catch {
                        continuation.finish(throwing: error)
                    }
                }
                continuation.onTermination = { _ in task.cancel() }
            }
        }
    }

}
