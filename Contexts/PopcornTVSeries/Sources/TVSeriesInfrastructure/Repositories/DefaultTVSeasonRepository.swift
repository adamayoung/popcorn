//
//  DefaultTVSeasonRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observability
import TVSeriesDomain

final class DefaultTVSeasonRepository: TVSeasonRepository {

    private let remoteDataSource: any TVSeasonRemoteDataSource
    private let localDataSource: any TVSeasonLocalDataSource

    init(
        remoteDataSource: some TVSeasonRemoteDataSource,
        localDataSource: some TVSeasonLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func season(
        _ seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVSeasonRepositoryError) -> TVSeason {
        let span = SpanContext.startChild(
            operation: .repositoryGet,
            description: "Fetch Season S\(seasonNumber) TV#\(tvSeriesID)"
        )
        span?.setData([
            "entity_type": "TVSeason",
            "tv_series_id": tvSeriesID,
            "season_number": seasonNumber
        ])

        do {
            if let cached = try await localDataSource.season(
                seasonNumber,
                inTVSeries: tvSeriesID
            ) {
                span?.setData(key: "cache.hit", value: true)
                span?.finish()
                return cached
            }
        } catch let error {
            let repositoryError = TVSeasonRepositoryError(error)
            span?.setData(error: repositoryError)
            span?.finish(status: .internalError)
            throw repositoryError
        }

        span?.setData(key: "cache.hit", value: false)

        let season: TVSeason
        do {
            season = try await remoteDataSource.season(
                seasonNumber,
                inTVSeries: tvSeriesID
            )
        } catch let error {
            let repositoryError = TVSeasonRepositoryError(error)
            span?.setData(error: repositoryError)
            span?.finish(status: .internalError)
            throw repositoryError
        }

        do {
            try await localDataSource.setSeason(season, inTVSeries: tvSeriesID)
        } catch let error {
            let repositoryError = TVSeasonRepositoryError(error)
            span?.setData(error: repositoryError)
            span?.finish(status: .internalError)
            throw repositoryError
        }

        span?.finish()
        return season
    }

}

private extension TVSeasonRepositoryError {

    init(_ error: Error) {
        if let error = error as? TVSeasonRemoteDataSourceError {
            self.init(error)
            return
        }

        if let error = error as? TVSeasonLocalDataSourceError {
            self.init(error)
            return
        }

        self = .unknown(error)
    }

    init(_ error: TVSeasonRemoteDataSourceError) {
        switch error {
        case .notFound: self = .notFound
        case .unauthorised: self = .unauthorised
        case .unknown(let error): self = .unknown(error)
        }
    }

    init(_ error: TVSeasonLocalDataSourceError) {
        switch error {
        case .persistence(let error): self = .unknown(error)
        case .unknown(let error): self = .unknown(error)
        }
    }

}
