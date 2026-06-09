//
//  TVEpisodeCastAndCrewDependencies.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import TVSeriesApplication

/// The dependencies required by ``TVEpisodeCastAndCrewViewModel``.
///
/// A plain `Sendable` struct of closures — the MVVM replacement for the former
/// `TVEpisodeCastAndCrewClient` (`@DependencyClient`). Constructing it requires
/// every closure, so a missing dependency is a compile error. Build the
/// production instance with ``live(services:)``.
public struct TVEpisodeCastAndCrewDependencies: Sendable {

    public var fetchCredits: @Sendable (
        _ tvSeriesID: Int,
        _ seasonNumber: Int,
        _ episodeNumber: Int
    ) async throws -> Credits

    public init(
        fetchCredits: @escaping @Sendable (
            _ tvSeriesID: Int,
            _ seasonNumber: Int,
            _ episodeNumber: Int
        ) async throws -> Credits
    ) {
        self.fetchCredits = fetchCredits
    }

}

public extension TVEpisodeCastAndCrewDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Mirrors the former `TVEpisodeCastAndCrewClient.liveValue` exactly: same use
    /// case, same mapper, same error translation.
    static func live(services: AppServices) -> TVEpisodeCastAndCrewDependencies {
        let fetchTVEpisodeCredits = services.tvSeriesFactory.makeFetchTVEpisodeCreditsUseCase()

        return TVEpisodeCastAndCrewDependencies(
            fetchCredits: { tvSeriesID, seasonNumber, episodeNumber in
                let creditsDetails: CreditsDetails

                do {
                    creditsDetails = try await fetchTVEpisodeCredits
                        .execute(
                            tvSeriesID: tvSeriesID,
                            seasonNumber: seasonNumber,
                            episodeNumber: episodeNumber
                        )
                } catch let error as FetchTVEpisodeCreditsError {
                    throw FetchCreditsError(error)
                }

                let mapper = CreditsMapper()
                return mapper.map(creditsDetails)
            }
        )
    }

}

#if DEBUG
    public extension TVEpisodeCastAndCrewDependencies {

        /// Mock dependencies for previews and snapshot tests (mirrors the former
        /// `TVEpisodeCastAndCrewClient.previewValue`).
        static var preview: TVEpisodeCastAndCrewDependencies {
            TVEpisodeCastAndCrewDependencies(
                fetchCredits: { _, _, _ in Credits.mock }
            )
        }

    }
#endif
