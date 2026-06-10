//
//  TVSeriesDetailsDependencies.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import Observability
import TVSeriesApplication

/// The dependencies required by ``TVSeriesDetailsViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``TVSeriesDetailsViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. Build the production instance with
/// ``live(services:)``.
public struct TVSeriesDetailsDependencies: Sendable {

    public var fetchTVSeries: @Sendable (_ id: Int) async throws -> TVSeries
    public var fetchCredits: @Sendable (_ tvSeriesID: Int) async throws -> Credits

    public var isCastAndCrewEnabled: @Sendable () throws -> Bool
    public var isIntelligenceEnabled: @Sendable () throws -> Bool
    public var isBackdropFocalPointEnabled: @Sendable () throws -> Bool

    public init(
        fetchTVSeries: @escaping @Sendable (_ id: Int) async throws -> TVSeries,
        fetchCredits: @escaping @Sendable (_ tvSeriesID: Int) async throws -> Credits,
        isCastAndCrewEnabled: @escaping @Sendable () throws -> Bool,
        isIntelligenceEnabled: @escaping @Sendable () throws -> Bool,
        isBackdropFocalPointEnabled: @escaping @Sendable () throws -> Bool
    ) {
        self.fetchTVSeries = fetchTVSeries
        self.fetchCredits = fetchCredits
        self.isCastAndCrewEnabled = isCastAndCrewEnabled
        self.isIntelligenceEnabled = isIntelligenceEnabled
        self.isBackdropFocalPointEnabled = isBackdropFocalPointEnabled
    }

}

public extension TVSeriesDetailsDependencies {

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

#if DEBUG
    public extension TVSeriesDetailsDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: TVSeriesDetailsDependencies {
            TVSeriesDetailsDependencies(
                fetchTVSeries: { _ in TVSeries.mock },
                fetchCredits: { _ in Credits.mock },
                isCastAndCrewEnabled: { true },
                isIntelligenceEnabled: { true },
                isBackdropFocalPointEnabled: { true }
            )
        }

    }
#endif
