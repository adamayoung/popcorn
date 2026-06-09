//
//  TVSeriesCastAndCrewDependencies.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import TVSeriesApplication

/// The dependencies required by ``TVSeriesCastAndCrewViewModel``.
///
/// A plain `Sendable` struct of closures — the MVVM replacement for the former
/// `TVSeriesCastAndCrewClient` (`@DependencyClient`). Constructing it requires every
/// closure, so a missing dependency is a compile error. Build the production
/// instance with ``live(services:)``.
public struct TVSeriesCastAndCrewDependencies: Sendable {

    public var fetchCredits: @Sendable (_ tvSeriesID: Int) async throws -> Credits

    public init(
        fetchCredits: @escaping @Sendable (_ tvSeriesID: Int) async throws -> Credits
    ) {
        self.fetchCredits = fetchCredits
    }

}

public extension TVSeriesCastAndCrewDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Mirrors the former `TVSeriesCastAndCrewClient.liveValue` exactly: same use
    /// case, same mapper, same error translation.
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

#if DEBUG
    public extension TVSeriesCastAndCrewDependencies {

        /// Mock dependencies for previews and snapshot tests (mirrors the former
        /// `TVSeriesCastAndCrewClient.previewValue`).
        static var preview: TVSeriesCastAndCrewDependencies {
            TVSeriesCastAndCrewDependencies(
                fetchCredits: { _ in Credits.mock }
            )
        }

    }
#endif
