//
//  DefaultTVSeriesCreditsRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

final class DefaultTVSeriesCreditsRepository: TVSeriesCreditsRepository {

    private let remoteDataSource: any TVSeriesRemoteDataSource
    private let localDataSource: any TVSeriesCreditsLocalDataSource
    private let aggregateCreditsLocalDataSource: any TVSeriesAggregateCreditsLocalDataSource

    init(
        remoteDataSource: some TVSeriesRemoteDataSource,
        localDataSource: some TVSeriesCreditsLocalDataSource,
        aggregateCreditsLocalDataSource: some TVSeriesAggregateCreditsLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.aggregateCreditsLocalDataSource = aggregateCreditsLocalDataSource
    }

    func credits(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesCreditsRepositoryError) -> Credits {
        do {
            if let cachedCredits = try await localDataSource.credits(forTVSeries: tvSeriesID) {
                return cachedCredits
            }
        } catch let error {
            throw TVSeriesCreditsRepositoryError(error)
        }

        let credits: Credits
        do {
            credits = try await remoteDataSource.credits(forTVSeries: tvSeriesID)
        } catch let error {
            throw TVSeriesCreditsRepositoryError(error)
        }

        try? await localDataSource.setCredits(credits, forTVSeries: tvSeriesID)

        return credits
    }

    func aggregateCredits(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesCreditsRepositoryError) -> AggregateCredits {
        do {
            let cached = try await aggregateCreditsLocalDataSource
                .aggregateCredits(forTVSeries: tvSeriesID)
            if let cached {
                return cached
            }
        } catch let error {
            throw TVSeriesCreditsRepositoryError(error)
        }

        let aggregateCredits: AggregateCredits
        do {
            aggregateCredits = try await remoteDataSource.aggregateCredits(
                forTVSeries: tvSeriesID
            )
        } catch let error {
            throw TVSeriesCreditsRepositoryError(error)
        }

        try? await aggregateCreditsLocalDataSource.setAggregateCredits(
            aggregateCredits,
            forTVSeries: tvSeriesID
        )

        return aggregateCredits
    }

}

extension TVSeriesCreditsRepositoryError {

    init(_ error: TVSeriesCreditsLocalDataSourceError) {
        switch error {
        case .persistence(let error):
            self = .unknown(error)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: TVSeriesAggregateCreditsLocalDataSourceError) {
        switch error {
        case .persistence(let error):
            self = .unknown(error)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: TVSeriesRemoteDataSourceError) {
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
