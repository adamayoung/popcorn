//
//  TVListingsRemoteDataSource.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

///
/// Fetches the partitioned, content-addressed EPG feed. The implementation is a set of
/// dumb fetchers; hash comparison and orchestration live in the sync repository.
///
public protocol TVListingsRemoteDataSource: Sendable {

    /// The manifest: the list of available dates and the content hash of every file.
    func fetchManifest() async throws(TVListingsRemoteDataSourceError) -> EPGManifest

    /// The channel directory (`channels.json`).
    func fetchChannels() async throws(TVListingsRemoteDataSourceError) -> [TVChannel]

    /// The region directory (`regions.json`).
    func fetchRegions() async throws(TVListingsRemoteDataSourceError) -> [TVRegion]

    /// The programmes for a single day (`schedules/<yyyyMMdd>.json`).
    func fetchSchedule(
        forDate date: String
    ) async throws(TVListingsRemoteDataSourceError) -> [TVProgramme]

}

public enum TVListingsRemoteDataSourceError: Error {

    case network(Error?)
    case decoding(Error?)
    case unknown(Error?)

}
