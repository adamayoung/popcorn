//
//  TVListingsRemoteDataSource.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

public protocol TVListingsRemoteDataSource: Sendable {

    func fetchListings() async throws(TVListingsRemoteDataSourceError) -> TVListingsSnapshot

}

///
/// A full snapshot of channels and programmes fetched from the remote EPG feed.
///
public struct TVListingsSnapshot: Sendable {

    public let channels: [TVChannel]
    public let programmes: [TVProgramme]

    public init(channels: [TVChannel], programmes: [TVProgramme]) {
        self.channels = channels
        self.programmes = programmes
    }

}

public enum TVListingsRemoteDataSourceError: Error {

    case network(Error?)
    case decoding(Error?)
    case unknown(Error?)

}
