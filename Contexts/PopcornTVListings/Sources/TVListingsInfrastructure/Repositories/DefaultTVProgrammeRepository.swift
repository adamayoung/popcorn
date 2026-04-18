//
//  DefaultTVProgrammeRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class DefaultTVProgrammeRepository: TVProgrammeRepository {

    private let localDataSource: any TVListingsLocalDataSource

    init(localDataSource: some TVListingsLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func programmes(
        forChannelID channelID: String,
        onDate date: Date
    ) async throws(TVListingsRepositoryError) -> [TVProgramme] {
        do {
            return try await localDataSource.programmes(forChannelID: channelID, onDate: date)
        } catch let error {
            throw TVListingsRepositoryError(error)
        }
    }

    func nowPlayingProgrammes(
        at date: Date
    ) async throws(TVListingsRepositoryError) -> [TVProgramme] {
        do {
            return try await localDataSource.nowPlayingProgrammes(at: date)
        } catch let error {
            throw TVListingsRepositoryError(error)
        }
    }

}
