//
//  DefaultTVEpisodeCreditsRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

final class DefaultTVEpisodeCreditsRepository: TVEpisodeCreditsRepository {

    private let remoteDataSource: any TVEpisodeRemoteDataSource
    private let localDataSource: any TVEpisodeCreditsLocalDataSource

    init(
        remoteDataSource: some TVEpisodeRemoteDataSource,
        localDataSource: some TVEpisodeCreditsLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func credits(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeCreditsRepositoryError) -> Credits {
        do {
            if let cachedCredits = try await localDataSource.credits(
                forEpisode: episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID
            ) {
                return cachedCredits
            }
        } catch let error {
            throw TVEpisodeCreditsRepositoryError(error)
        }

        let credits: Credits
        do {
            credits = try await remoteDataSource.credits(
                forEpisode: episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID
            )
        } catch let error {
            throw TVEpisodeCreditsRepositoryError(error)
        }

        try? await localDataSource.setCredits(
            credits,
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        return credits
    }

}

extension TVEpisodeCreditsRepositoryError {

    init(_ error: TVEpisodeCreditsLocalDataSourceError) {
        switch error {
        case .persistence(let error):
            self = .unknown(error)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: TVEpisodeRemoteDataSourceError) {
        switch error {
        case .notFound:
            self = .notFound
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
