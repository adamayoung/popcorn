//
//  DefaultTVListingsSyncRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class DefaultTVListingsSyncRepository: TVListingsSyncRepository {

    private let remoteDataSource: any TVListingsRemoteDataSource
    private let localDataSource: any TVListingsLocalDataSource

    init(
        remoteDataSource: some TVListingsRemoteDataSource,
        localDataSource: some TVListingsLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func sync() async throws(TVListingsRepositoryError) {
        let snapshot: TVListingsSnapshot
        do {
            snapshot = try await remoteDataSource.fetchListings()
        } catch let error {
            throw TVListingsRepositoryError(error)
        }

        do {
            try await localDataSource.replaceAll(
                channels: snapshot.channels,
                programmes: snapshot.programmes
            )
        } catch let error {
            throw TVListingsRepositoryError(error)
        }
    }

}
