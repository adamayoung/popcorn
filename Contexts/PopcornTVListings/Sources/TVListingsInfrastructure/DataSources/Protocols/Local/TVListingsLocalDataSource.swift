//
//  TVListingsLocalDataSource.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

public protocol TVListingsLocalDataSource: Actor {

    func channels() async throws(TVListingsLocalDataSourceError) -> [TVChannel]

    func programmes(
        forChannelID channelID: String,
        onDate date: Date
    ) async throws(TVListingsLocalDataSourceError) -> [TVProgramme]

    func nowPlayingProgrammes(
        at date: Date
    ) async throws(TVListingsLocalDataSourceError) -> [TVProgramme]

    func replaceAll(
        channels: [TVChannel],
        programmes: [TVProgramme]
    ) async throws(TVListingsLocalDataSourceError)

}

public enum TVListingsLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
