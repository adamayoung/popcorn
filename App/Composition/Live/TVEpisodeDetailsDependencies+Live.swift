//
//  TVEpisodeDetailsDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import FeatureAccess
import TVEpisodeDetailsFeature
import TVSeriesApplication
import TVSeriesComposition

extension TVEpisodeDetailsDependencies {

    /// Builds the production dependencies from the app's shared services,
    /// wiring the use cases, mappers, feature flag, and error wrapping.
    static func live(services: AppServices) -> TVEpisodeDetailsDependencies {
        let fetchTVEpisodeDetails = services.tvSeriesFactory.makeFetchTVEpisodeDetailsUseCase()
        let fetchTVEpisodeCredits = services.tvSeriesFactory.makeFetchTVEpisodeCreditsUseCase()
        let featureFlags = services.featureFlags

        return TVEpisodeDetailsDependencies(
            fetchEpisode: { tvSeriesID, seasonNumber, episodeNumber in
                do {
                    let details = try await fetchTVEpisodeDetails.execute(
                        tvSeriesID: tvSeriesID,
                        seasonNumber: seasonNumber,
                        episodeNumber: episodeNumber
                    )
                    let mapper = TVEpisodeMapper()
                    return mapper.map(details)
                } catch let error as FetchTVEpisodeDetailsError {
                    throw FetchEpisodeDetailsError(error)
                }
            },
            fetchCredits: { tvSeriesID, seasonNumber, episodeNumber in
                let creditsDetails = try await fetchTVEpisodeCredits.execute(
                    tvSeriesID: tvSeriesID,
                    seasonNumber: seasonNumber,
                    episodeNumber: episodeNumber
                )
                let mapper = CreditsMapper()
                return mapper.map(creditsDetails)
            },
            isCastAndCrewEnabled: {
                featureFlags.isEnabled(.tvEpisodeDetailsCastAndCrew)
            }
        )
    }

}
