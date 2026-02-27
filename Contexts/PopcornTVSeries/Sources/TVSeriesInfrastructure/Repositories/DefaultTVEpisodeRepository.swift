//
//  DefaultTVEpisodeRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observability
import TVSeriesDomain

final class DefaultTVEpisodeRepository: TVEpisodeRepository {

    private let remoteDataSource: any TVEpisodeRemoteDataSource
    private let localDataSource: any TVEpisodeLocalDataSource

    init(
        remoteDataSource: some TVEpisodeRemoteDataSource,
        localDataSource: some TVEpisodeLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func episode(
        _ episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeRepositoryError) -> TVEpisode {
        let span = SpanContext.startChild(
            operation: .repositoryGet,
            description: "Fetch Episode S\(seasonNumber)E\(episodeNumber) TV#\(tvSeriesID)"
        )
        span?.setData([
            "entity_type": "TVEpisode",
            "tv_series_id": tvSeriesID,
            "season_number": seasonNumber,
            "episode_number": episodeNumber
        ])

        do {
            if let cached = try await localDataSource.episode(
                episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID
            ) {
                span?.setData(key: "cache.hit", value: true)
                span?.finish()
                return cached
            }
        } catch let error {
            let repositoryError = TVEpisodeRepositoryError(error)
            span?.setData(error: repositoryError)
            span?.finish(status: .internalError)
            throw repositoryError
        }

        span?.setData(key: "cache.hit", value: false)

        let episode: TVEpisode
        do {
            episode = try await remoteDataSource.episode(
                episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID
            )
        } catch let error {
            let repositoryError = TVEpisodeRepositoryError(error)
            span?.setData(error: repositoryError)
            span?.finish(status: .internalError)
            throw repositoryError
        }

        try? await localDataSource.setEpisode(episode, inTVSeries: tvSeriesID)

        span?.finish()
        return episode
    }

}

private extension TVEpisodeRepositoryError {

    init(_ error: Error) {
        if let error = error as? TVEpisodeRemoteDataSourceError {
            self.init(error)
            return
        }

        if let error = error as? TVEpisodeLocalDataSourceError {
            self.init(error)
            return
        }

        self = .unknown(error)
    }

    init(_ error: TVEpisodeRemoteDataSourceError) {
        switch error {
        case .notFound: self = .notFound
        case .unauthorised: self = .unauthorised
        case .unknown(let error): self = .unknown(error)
        }
    }

    init(_ error: TVEpisodeLocalDataSourceError) {
        switch error {
        case .persistence(let error): self = .unknown(error)
        case .unknown(let error): self = .unknown(error)
        }
    }

}
