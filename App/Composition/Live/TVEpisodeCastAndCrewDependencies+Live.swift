//
//  TVEpisodeCastAndCrewDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import TVEpisodeCastAndCrewFeature
import TVSeriesApplication
import TVSeriesComposition

extension TVEpisodeCastAndCrewDependencies {

    /// Builds the production dependencies from the app's shared services,
    /// wiring the use case, mapper, and error translation.
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
