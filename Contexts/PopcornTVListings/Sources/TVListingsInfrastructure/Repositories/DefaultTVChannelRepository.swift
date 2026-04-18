//
//  DefaultTVChannelRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class DefaultTVChannelRepository: TVChannelRepository {

    private let localDataSource: any TVListingsLocalDataSource

    init(localDataSource: some TVListingsLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func channels() async throws(TVListingsRepositoryError) -> [TVChannel] {
        do {
            return try await localDataSource.channels()
        } catch let error {
            throw TVListingsRepositoryError(error)
        }
    }

}
