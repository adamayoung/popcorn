//
//  TVProgrammeRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides read access to locally cached TV programmes.
///
public protocol TVProgrammeRepository: Sendable {

    func programmes(
        forChannelID channelID: String,
        onDate date: Date
    ) async throws(TVListingsRepositoryError) -> [TVProgramme]

    func nowPlayingProgrammes(
        at date: Date
    ) async throws(TVListingsRepositoryError) -> [TVProgramme]

}
