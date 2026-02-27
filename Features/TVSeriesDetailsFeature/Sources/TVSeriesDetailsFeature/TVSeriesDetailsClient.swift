//
//  TVSeriesDetailsClient.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import Observability
import TVSeriesApplication

@DependencyClient
struct TVSeriesDetailsClient: Sendable {

    var fetchTVSeries: @Sendable (Int) async throws -> TVSeries
    var fetchCredits: @Sendable (_ tvSeriesID: Int) async throws -> Credits

    var isCastAndCrewEnabled: @Sendable () throws -> Bool
    var isIntelligenceEnabled: @Sendable () throws -> Bool
    var isBackdropFocalPointEnabled: @Sendable () throws -> Bool

}

extension TVSeriesDetailsClient: DependencyKey {

    static var liveValue: TVSeriesDetailsClient {
        @Dependency(\.fetchTVSeriesDetails) var fetchTVSeriesDetails
        @Dependency(\.fetchTVSeriesCredits) var fetchTVSeriesCredits
        @Dependency(\.featureFlags) var featureFlags

        return TVSeriesDetailsClient(
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
                    throw error
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
            isCastAndCrewEnabled: {
                featureFlags.isEnabled(.tvSeriesDetailsCastAndCrew)
            },
            isIntelligenceEnabled: {
                featureFlags.isEnabled(.tvSeriesIntelligence)
            },
            isBackdropFocalPointEnabled: {
                featureFlags.isEnabled(.backdropFocalPoint)
            }
        )
    }

    static var previewValue: TVSeriesDetailsClient {
        TVSeriesDetailsClient(
            fetchTVSeries: { _ in
                TVSeries.mock
            },
            fetchCredits: { _ in
                Credits.mock
            },
            isCastAndCrewEnabled: {
                true
            },
            isIntelligenceEnabled: {
                true
            },
            isBackdropFocalPointEnabled: {
                true
            }
        )
    }

}

extension DependencyValues {

    var tvSeriesDetailsClient: TVSeriesDetailsClient {
        get { self[TVSeriesDetailsClient.self] }
        set { self[TVSeriesDetailsClient.self] = newValue }
    }

}
