//
//  TVSeriesCastAndCrewClient.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import TVSeriesApplication

@DependencyClient
struct TVSeriesCastAndCrewClient {

    var fetchCredits: @Sendable (_ tvSeriesID: Int) async throws -> Credits

}

extension TVSeriesCastAndCrewClient: DependencyKey {

    static var liveValue: TVSeriesCastAndCrewClient {
        @Dependency(\.fetchTVSeriesAggregateCredits) var fetchTVSeriesAggregateCredits

        return TVSeriesCastAndCrewClient(
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

    static var previewValue: TVSeriesCastAndCrewClient {
        TVSeriesCastAndCrewClient(
            fetchCredits: { _ in
                Credits.mock
            }
        )
    }

}

extension DependencyValues {

    var tvSeriesCastAndCrewClient: TVSeriesCastAndCrewClient {
        get { self[TVSeriesCastAndCrewClient.self] }
        set { self[TVSeriesCastAndCrewClient.self] = newValue }
    }

}
