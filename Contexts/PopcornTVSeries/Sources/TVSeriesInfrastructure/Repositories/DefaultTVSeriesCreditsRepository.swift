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

    init(
        remoteDataSource: some TVSeriesRemoteDataSource,
        localDataSource: some TVSeriesCreditsLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
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
