//
//  TVSeasonDetailsDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import TVSeasonDetailsFeature
import TVSeriesApplication
import TVSeriesComposition

extension TVSeasonDetailsDependencies {

    /// Builds the production dependencies from the app's shared services,
    /// wiring the use case, mappers, and error wrapping.
    static func live(services: AppServices) -> TVSeasonDetailsDependencies {
        let fetchTVSeasonDetails = services.tvSeriesFactory.makeFetchTVSeasonDetailsUseCase()

        return TVSeasonDetailsDependencies(
            fetchSeasonAndEpisodes: { tvSeriesID, seasonNumber in
                do {
                    let details = try await fetchTVSeasonDetails.execute(
                        tvSeriesID: tvSeriesID,
                        seasonNumber: seasonNumber
                    )
                    let seasonMapper = TVSeasonMapper()
                    let episodeMapper = TVEpisodeMapper()

                    let season = seasonMapper.map(details)
                    let episodes = details.episodes.map(episodeMapper.map)

                    return (season, episodes)
                } catch let error as FetchTVSeasonDetailsError {
                    throw FetchSeasonDetailsError(error)
                }
            }
        )
    }

}
